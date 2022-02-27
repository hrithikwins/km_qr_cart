import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/cart_summary/bindings/cart_summary_binding.dart';
import '../modules/home/cart_summary/views/cart_summary_view.dart';
import '../modules/home/qr_scan/bindings/qr_scan_binding.dart';
import '../modules/home/qr_scan/views/qr_scan_view.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.QR_SCAN,
          page: () => QrScanView(),
          binding: QrScanBinding(),
        ),
        GetPage(
          name: _Paths.CART_SUMMARY,
          page: () => CartSummaryView(),
          binding: CartSummaryBinding(),
        ),
      ],
    ),
  ];
}
