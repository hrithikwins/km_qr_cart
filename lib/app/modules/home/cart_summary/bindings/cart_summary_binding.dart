import 'package:get/get.dart';

import '../controllers/cart_summary_controller.dart';

class CartSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartSummaryController>(
      () => CartSummaryController(),
    );
  }
}
