import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technical_flutter/controller/cart_controller.dart';
import 'package:technical_flutter/controller/product_controller.dart';
import 'package:technical_flutter/model/product_model.dart';
import 'package:technical_flutter/page/cart_page.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  ProductDetailPage({Key? key, required this.productId}) : super(key: key);

  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: Column(
        children: [
          Center(
            child: GetBuilder<ProductController>(
              builder: (controller) {
                Product? product = controller.getCachedProduct(productId);

                if (product == null) {
                  // If the product is not in the cache, fetch it
                  return FutureBuilder<Product?>(
                    future: productController.getProductById(productId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Text('Product not found');
                      } else {
                        productController.cacheProduct(snapshot.data!);
                        return _buildProductDetails(context, snapshot.data!);
                      }
                    },
                  );
                } else {
                  // If the product is in the cache, use the cached data
                  return _buildProductDetails(context, product);
                }
              },
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Product? product =
                    productController.getCachedProduct(productId);
                if (product != null) {
                  cartController.addToCart(product);
                  Get.snackbar('Added to Cart', 'Product added to the cart');
                }
                Get.to(() => CartPage());
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.blue,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Icon(Icons.shopping_cart)),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context, Product product) {
    // Build the UI using the cached product data
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CachedNetworkImage(
            imageUrl: product.thumbnail ?? "",
            width: MediaQuery.of(context)
                .size
                .width, // Adjust the factor as needed
            height: MediaQuery.of(context)
                .size
                .width, // Adjust the factor as needed
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20),
              child: Text(
                product.name!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '\$${product.price?.toStringAsFixed(2)}',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Discount : ${product.discount}%',
                  style: const TextStyle(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rating : ${product.rating}',
                  style: const TextStyle(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Category : ${product.category}',
                  style: const TextStyle(),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    'Description :',
                    style: TextStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${product.description}',
                      style: const TextStyle(),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
