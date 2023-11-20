import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:technical_flutter/controller/product_controller.dart';
import 'package:technical_flutter/model/product_model.dart';
import 'package:technical_flutter/page/product_detail.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;
  final DefaultCacheManager cacheManager;
  final scrollController = ScrollController();
  final ProductController productController = Get.find<ProductController>();

  ProductList({super.key, required this.products, required this.cacheManager});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: products.length + 1,
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index < products.length) {
          final product = products[index];
          return InkWell(
            onTap: () {
              log("PRODUCT ID: ${product.id}");
              Get.to(() => ProductDetailPage(productId: product.id!));
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[200]!, // Warna border
                    width: 1.0, // Lebar border
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CachedNetworkImage(
                        cacheManager: cacheManager,
                        imageUrl: product.thumbnail ?? "",
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product.name!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('\$${product.price?.toStringAsFixed(2)}'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          if (!productController.isLoading.value &&
              !productController.isEnd.value &&
              !productController.isSearching.value) {
            // Load more data when reaching the end
            productController.fetchMoreProducts(products.length);
          }
          //return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
