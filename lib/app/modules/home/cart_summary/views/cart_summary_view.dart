import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:km_qr_cart/app/routes/app_pages.dart';

import '../controllers/cart_summary_controller.dart';

class CartSummaryView extends GetView<CartSummaryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Summary'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Row(
          children: [
            Icon(Icons.add),
            Text('Add Items to Cart'),
          ],
        ),
        onPressed: () {
          Get.toNamed(
            Routes.QR_SCAN,
          );
        },
      ),
      //a screen which shows all the cart details here
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Text(
            //   'Total Items: ${controller.cartItems.length}',
            //   style: TextStyle(fontSize: 20),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => Text(
                    //rupee symbol
                    'Cart Total:  \u20B9 ${controller.totalPrice.value}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  child: Text('Checkout'),
                  onPressed: () {
                    Get.toNamed(
                      Routes.CHECKOUT,
                      arguments: controller.totalPrice.value,
                    );
                  },
                ),
              ],
            ),
            Obx(
              () => Container(
                color: Colors.tealAccent.shade100,
                child: SizedBox(
                  height: Get.height * 0.75,
                  child: ListView(
                    children: [
                      for (var item in controller.cartItems)
                        ListTile(
                          title: Text(item['name']),
                          subtitle: Text(' ${item['weight']} grams'),
                          trailing: Text('\u20B9 ${item['price']}'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
