import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:technical_flutter/controller/cart_controller.dart';
import 'package:technical_flutter/controller/product_controller.dart';
import 'package:technical_flutter/page/cart_page.dart';
import 'package:technical_flutter/page/product_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cacheManager = DefaultCacheManager();
  Get.put(ProductController());
  Get.put(CartController());
  runApp(GetMaterialApp(
    home: Home(cacheManager: cacheManager),
  ));
}

class SearchController extends GetxController {
  final searchText = ''.obs;
}

class Home extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();
  final DefaultCacheManager cacheManager;
  final SearchController searchController = Get.put(SearchController());
  // bool isSearching = false;
  // bool hasSearched = false;

  Home({super.key, required this.cacheManager});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.store_mall_directory, size: 32),
              Text(
                "TOKOPAEDI",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Get.to(() => CartPage());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Product",
                      ),
                      onChanged: (text) {
                        searchController.searchText.value = text;
                        // hasSearched = true;
                        productController.isSearching(true);
                        productController
                            .searchProduct(searchController.searchText.value);
                        if (text.isEmpty) {
                          searchController.searchText.value =
                              ''; // Clear searchText value
                          // hasSearched = false;
                          productController.isSearching(false);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final filteredProducts =
                  productController.products.where((product) {
                return product.name!
                    .toLowerCase()
                    .contains(searchController.searchText.value.toLowerCase());
              }).toList();
              return ProductList(
                products: filteredProducts,
                cacheManager: cacheManager,
              );
            }),
          ),
        ],
      ),
    );
  }
}
