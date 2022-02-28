import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout & Pay'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(() => UserInfo(title: "Name: ", value: controller.name.value)),
          Obx(() => UserInfo(title: "Email: ", value: controller.email.value)),
          Obx(() => UserInfo(title: "Phone: ", value: controller.phone.value)),
          Obx(() => UserInfo(
              title: "Trolley Number: ",
              value: controller.trolleyNumber.value)),
          //rupee symbol
          UserInfo(title: "Total: \u20B9 ", value: Get.arguments.toString()),
          //checkout page
          ElevatedButton(
            onPressed: () {
              controller.pay();
            },
            child: Text('Pay \u20B9 ${Get.arguments.toString()}'),
          ),
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              color: Colors.teal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
