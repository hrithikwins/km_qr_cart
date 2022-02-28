import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:km_qr_cart/app/routes/app_pages.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  var name = ''.obs;

  var email = "".obs;
  var phone = "".obs;
  var trolleyNumber = "".obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    // if (GetStorage().read('name') != null ||
    //     GetStorage().read('name') != "" ||
    //     GetStorage().read('name') != " ") {
    //   Get.toNamed(Routes.CART_SUMMARY);
    // }
    super.onReady();
  }

  @override
  void onClose() {}

  void increment() => count.value++;
  validate() {
    if (name.value.length == 0) {
      Get.snackbar("Name", "Name is required");
    } else if (email.value.length == 0) {
      Get.snackbar("Email", "Email is required");
    } else if (phone.value.length == 0) {
      Get.snackbar("Phone", "Phone is required");
    } else if (trolleyNumber.value.length == 0) {
      Get.snackbar("Trolley Number", "Trolley Number is required");
    } else {
      //writing these values to local storage
      var storageBox = GetStorage();
      storageBox.write("name", name.value);
      storageBox.write("email", email.value);
      storageBox.write("phone", phone.value);
      storageBox.write("trolleyNumber", trolleyNumber.value);
      Get.toNamed(
        Routes.CART_SUMMARY,
      );
    }
  }
}
