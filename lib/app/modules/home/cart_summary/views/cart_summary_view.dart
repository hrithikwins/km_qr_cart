import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/cart_summary_controller.dart';

class CartSummaryView extends GetView<CartSummaryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CartSummaryView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'CartSummaryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
