import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:km_qr_cart/app/routes/app_pages.dart';

class CheckoutController extends GetxController {
  //TODO: Implement CheckoutController

  final count = 0.obs;
  var storageBox = GetStorage();

  final name = "".obs;
  final email = "".obs;
  final phone = "".obs;
  final trolleyNumber = "".obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    readUserDetails();
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  void readUserDetails() {

    name.value = storageBox.read('name');
    email.value = storageBox.read('email');
    phone.value = storageBox.read('phone');
    trolleyNumber.value = storageBox.read('trolleyNumber');
  }

  void pay() {
    //clearing all details
    storageBox.write("products", []);
    storageBox.write('name', "");
    storageBox.write('email', "");
    storageBox.write('phone', "");
    storageBox.write('trolleyNumber', "");
    //redirecting to the home page
    Get.offAllNamed(Routes.HOME);
    //success snackbar
    Get.snackbar(
      "Success",
      "Payment Successful",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 10,
      margin: EdgeInsets.all(10),
      snackStyle: SnackStyle.FLOATING,
      duration: Duration(seconds: 2),
      animationDuration: Duration(milliseconds: 500),
    );
  }
}
