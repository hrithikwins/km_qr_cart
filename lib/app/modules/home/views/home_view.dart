import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:km_qr_cart/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'HomeView is working',
              style: TextStyle(fontSize: 20),
            ),
          ),
          ElevatedButton(
            onPressed: () => {Get.toNamed(Routes.QR_SCAN)},
            child: Text("SCAN QR"),
          ),
        ],
      ),
    );
  }
}
