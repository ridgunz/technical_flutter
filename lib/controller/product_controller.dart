import 'dart:developer';

import 'package:get/get.dart';
import 'package:technical_flutter/model/product_model.dart';
import 'package:technical_flutter/repository/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository _repository = ProductRepository();
  var products = <Product>[].obs;
  var isLoading = false.obs;
  var isEnd = false.obs;
  var isSearching = false.obs;

  // Map to store cached products
  final Map<int, Product> _cachedProducts = {};

  // Method to get a cached product by ID
  Product? getCachedProduct(int productId) {
    return _cachedProducts[productId];
  }

  // Method to cache a product
  void cacheProduct(Product product) {
    _cachedProducts[product.id!] = product;
  }

  void fetchMoreProducts(int panjang) async {
    try {
      isLoading(true);
      final List<Product> moreProducts =
          await _repository.fetchMoreProducts(panjang);
      if (moreProducts.isNotEmpty) {
        products.addAll(moreProducts);
      } else {
        isEnd(true);
      }
    } finally {
      isLoading(false);
    }
  }

  void searchProduct(String product) async {
    try {
      isLoading(true);
      final List<Product> searchProducts =
          await _repository.searchProduct(product);
      if (searchProducts.isNotEmpty) {
        products.assignAll(searchProducts);
        //update();
        Get.forceAppUpdate();
      } else {
        isEnd(true);
      }
    } finally {
      isLoading(false);
    }
  }

  // Future<Product?> getProductById(int productId) async {
  //   try {
  //     isLoading(true);
  //     final Product? product = await _repository.getProductById(productId);
  //     return product;
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  Future<Product?> getProductById(int productId) async {
    try {
      isLoading(true);

      // Check if the product is already cached
      Product? cachedProduct = getCachedProduct(productId);

      if (cachedProduct != null) {
        // If the product is in the cache, return it
        return cachedProduct;
      } else {
        // If not in the cache, fetch it from the repository
        final Product? product = await _repository.getProductById(productId);

        // Cache the fetched product
        if (product != null) {
          cacheProduct(product);
        }

        return product;
      }
    } finally {
      isLoading(false);
    }
  }
}
