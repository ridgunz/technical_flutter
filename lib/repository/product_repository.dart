import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:technical_flutter/model/product_model.dart';
import '../url/url.dart';

class ProductRepository {
  final Dio _dio = Dio();
  var products = <Product>[].obs;
  final pageSize = 10; // Jumlah data per halaman
  final totalLimit = 100; // Batasan total data
  String url = UrlHelper.apiUrl;
  var isEnd = false.obs;
  var isLoading = false.obs;

  Future<List<Product>> fetchMoreProducts(int panjang) async {
    try {
      log("PRODUCTS LENGTH: $panjang");

      if (panjang < totalLimit) {
        final response = await _dio.get('$url?limit=$pageSize&skip=$panjang');

        if (response.statusCode == 200) {
          List<dynamic> productsData = response.data['products'];
          List<Product> products = productsData.map((item) {
            return Product(
              name: item['title'],
              price: double.parse(item['price'].toString()),
              description: item['description'],
              thumbnail: item['thumbnail'],
              id: item['id'],
            );
          }).toList();

          return products;
        } else {
          throw Exception('Failed to load products');
        }
      } else {
        log("BATAS AKHIR");
        isEnd(true);
        return products;
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<Product>> searchProduct(String product) async {
    try {
      log("PRODUCTS SEARCH: $product");
      final response = await _dio.get('$url/search?q=$product');

      if (response.statusCode == 200) {
        List<dynamic> productsData = response.data['products'];
        List<Product> products = productsData.map((item) {
          return Product(
            name: item['title'],
            price: double.parse(item['price'].toString()),
            description: item['description'],
            thumbnail: item['thumbnail'],
            id: item['id'],
          );
        }).toList();

        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<Product?> getProductById(int productId) async {
    try {
      final response = await _dio.get('$url/$productId');

      if (response.statusCode == 200) {
        dynamic productData = response.data;
        Product product = Product(
            name: productData['title'],
            price: double.parse(productData['price'].toString()),
            description: productData['description'],
            thumbnail: productData['thumbnail'],
            id: productData['id'],
            discount:
                double.parse(productData['discountPercentage'].toString()),
            rating: double.parse(productData['rating'].toString()),
            category: productData['category']);

        log("HIT PRODUCT SINGLE!");
        return product;
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      throw Exception('Error fetching product details: $e');
    }
  }
}
