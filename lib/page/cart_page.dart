import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technical_flutter/controller/cart_controller.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();

  CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () {
                double total = cartController.calculateTotal();

                return cartController.cartItems.isEmpty
                    ? const Center(
                        child: Text('Your cart is empty'),
                      )
                    : ListView.builder(
                        itemCount: cartController.cartItems.length,
                        itemBuilder: (context, index) {
                          var product = cartController.cartItems[index];
                          return ListTile(
                            leading: Image.network(
                              product.thumbnail ?? "",
                              width: 50,
                              height: 50,
                            ),
                            title: Text(product.name ?? ''),
                            subtitle: Text(
                                'Price: \$${product.price?.toStringAsFixed(2)}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                cartController.removeFromCart(product);
                              },
                            ),
                          );
                        },
                      );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () {
                double total = cartController.calculateTotal();
                return Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
