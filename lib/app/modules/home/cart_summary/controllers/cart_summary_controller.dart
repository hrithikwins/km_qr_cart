import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CartSummaryController extends GetxController {
  //TODO: Implement CartSummaryController
  var storageBox = GetStorage();

  final count = 0.obs;
  var totalPrice = 0.obs;
  var cartItems = [].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    refreshCart();
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  refreshCart() {
    cartItems.value = storageBox.read('products');
    calculateTotalPrice();
    refresh();
  }

  clearCart() {
    storageBox.write('products', []);
    totalPrice.value = 0;
    cartItems.clear();
  }

  calculateTotalPrice() {
    totalPrice.value = 0;
    cartItems.value.forEach((element) {
      totalPrice.value += int.parse(element['price']);
    });
  }
}
