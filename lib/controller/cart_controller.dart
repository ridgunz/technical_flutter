import 'package:get/get.dart';
import 'package:technical_flutter/model/product_model.dart';

class CartController extends GetxController {
  RxList<Product> cartItems = <Product>[].obs;

  void addToCart(Product product) {
    cartItems.add(product);
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
  }

  int getCartItemCount() {
    return cartItems.length;
  }

  double calculateTotal() {
    double total = 0.0;

    for (var product in cartItems) {
      if (product.price != null) {
        total += product.price!;
      }
    }

    return total;
  }
}
