import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:km_qr_cart/app/modules/home/cart_summary/controllers/cart_summary_controller.dart';
import 'package:km_qr_cart/app/modules/home/controllers/home_controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../controllers/qr_scan_controller.dart';

class QrScanView extends StatefulWidget {
  const QrScanView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrScanViewState();
}

class _QrScanViewState extends State<QrScanView> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    CartSummaryController controller = Get.put(CartSummaryController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Shopping cart'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 200, child: _buildQrView(context)),
          SizedBox(
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (result != null)
                  SizedBox(
                    height: Get.height - 300,
                    width: Get.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: Get.height - 400,
                          width: Get.width,
                          child: Card(
                            elevation: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                productCard(
                                    "Product name",
                                    jsonDecode(
                                        result!.code.toString())["name"]),
                                productCard(
                                    "Product Price",
                                    "\u20B9" +
                                        jsonDecode(
                                            result!.code.toString())["price"]),
                                productCard(
                                    "Weight (in grams)",
                                    jsonDecode(
                                        result!.code.toString())["weight"]),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: Text('ADD TO CART'),
                            onPressed: () {
                              var storageBox = GetStorage();
                              storageBox.writeIfNull("products", []);
                              var products = storageBox.read("products");
                              products.add(jsonDecode(result!.code.toString()));
                              storageBox.write("products", products);

                              controller.refreshCart();
                              Get.back();
                              // Get.snackbar(
                              //   "Added to cart",
                              //   "Added to cart",
                              //   snackPosition: SnackPosition.TOP,
                              //   backgroundColor: Colors.green,
                              //   borderRadius: 10,
                              //   margin: EdgeInsets.all(10),
                              //   borderColor: Colors.green,
                              //   colorText: Colors.white,
                              // );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(38.0),
                    child: const Text('Scan the special code to add to cart'),
                  ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: <Widget>[
                //     Container(
                //       margin: const EdgeInsets.all(8),
                //       child: ElevatedButton(
                //           onPressed: () async {
                //             await controller?.toggleFlash();
                //             setState(() {});
                //           },
                //           child: FutureBuilder(
                //             future: controller?.getFlashStatus(),
                //             builder: (context, snapshot) {
                //               return Text('Flash: ${snapshot.data}');
                //             },
                //           )),
                //     ),
                //     Container(
                //       margin: const EdgeInsets.all(8),
                //       child: ElevatedButton(
                //           onPressed: () async {
                //             await controller?.flipCamera();
                //             setState(() {});
                //           },
                //           child: FutureBuilder(
                //             future: controller?.getCameraInfo(),
                //             builder: (context, snapshot) {
                //               if (snapshot.data != null) {
                //                 return Text(
                //                     'Camera facing ${describeEnum(snapshot.data!)}');
                //               } else {
                //                 return const Text('loading');
                //               }
                //             },
                //           )),
                //     )
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: <Widget>[
                //     Container(
                //       margin: const EdgeInsets.all(8),
                //       child: ElevatedButton(
                //         onPressed: () async {
                //           await controller?.pauseCamera();
                //         },
                //         child: const Text('pause',
                //             style: TextStyle(fontSize: 20)),
                //       ),
                //     ),
                //     Container(
                //       margin: const EdgeInsets.all(8),
                //       child: ElevatedButton(
                //         onPressed: () async {
                //           await controller?.resumeCamera();
                //         },
                //         child: const Text('resume',
                //             style: TextStyle(fontSize: 20)),
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Column productCard(title, data) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          data,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}


// class QrScanView extends StatefulWidget {
//   const QrScanView({Key? key}) : super(key: key);

//   @override
//   _QrScanViewState createState() => _QrScanViewState();
// }

// class _QrScanViewState extends State<QrScanView>
//     with SingleTickerProviderStateMixin {
//   String? barcode;

//   MobileScannerController controller = MobileScannerController(
//     torchEnabled: true,
//     facing: CameraFacing.front,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.black,
//         body: Builder(builder: (context) {
//           return Stack(
//             children: [
//               MobileScanner(
//                   controller: controller,
//                   fit: BoxFit.contain,
//                   // controller: MobileScannerController(
//                   //   torchEnabled: true,
//                   //   facing: CameraFacing.front,
//                   // ),
//                   onDetect: (barcode, args) {
//                     if (this.barcode != barcode.rawValue) {
//                       setState(() {
//                         this.barcode = barcode.rawValue;
//                       });
//                     }
//                   }),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   alignment: Alignment.bottomCenter,
//                   height: 100,
//                   color: Colors.black.withOpacity(0.4),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       IconButton(
//                         color: Colors.white,
//                         icon: ValueListenableBuilder(
//                           valueListenable: controller.torchState,
//                           builder: (context, state, child) {
//                             switch (state as TorchState) {
//                               case TorchState.off:
//                                 return const Icon(Icons.flash_off,
//                                     color: Colors.grey);
//                               case TorchState.on:
//                                 return const Icon(Icons.flash_on,
//                                     color: Colors.yellow);
//                             }
//                           },
//                         ),
//                         iconSize: 32.0,
//                         onPressed: () => controller.toggleTorch(),
//                       ),
//                       Center(
//                         child: SizedBox(
//                           width: MediaQuery.of(context).size.width - 120,
//                           height: 50,
//                           child: FittedBox(
//                             child: Text(
//                               barcode ?? 'Scan something!',
//                               overflow: TextOverflow.fade,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .headline4!
//                                   .copyWith(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         color: Colors.white,
//                         icon: ValueListenableBuilder(
//                           valueListenable: controller.cameraFacingState,
//                           builder: (context, state, child) {
//                             switch (state as CameraFacing) {
//                               case CameraFacing.front:
//                                 return const Icon(Icons.camera_front);
//                               case CameraFacing.back:
//                                 return const Icon(Icons.camera_rear);
//                             }
//                           },
//                         ),
//                         iconSize: 32.0,
//                         onPressed: () => controller.switchCamera(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // Container(
//               //   alignment: Alignment.bottomCenter,
//               //   margin: EdgeInsets.only(bottom: 80.0),
//               //   child: IconButton(
//               //     icon: ValueListenableBuilder(
//               //       valueListenable: cameraController.torchState,
//               //       builder: (context, state, child) {
//               //         final color =
//               //             state == TorchState.off ? Colors.grey : Colors.white;
//               //         return Icon(Icons.bolt, color: color);
//               //       },
//               //     ),
//               //     iconSize: 32.0,
//               //     onPressed: () => cameraController.torch(),
//               //   ),
//               // ),
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     // cameraController.dispose();
//     super.dispose();
//   }

//   void display(Barcode barcode) {
//     Navigator.of(context).popAndPushNamed('display', arguments: barcode);
//   }
// }


// -------other one
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
//
// void main() {
//   debugPaintSizeEnabled = false;
//   runApp(HomePage());
// }
//
// class HomePage extends StatefulWidget {
//   @override
//   HomeState createState() => HomeState();
// }
//
// class HomeState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: MyApp());
//   }
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   String? qr;
//   bool camState = false;
//
//   @override
//   initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Plugin example app'),
//       ),
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Expanded(
//                 child: camState
//                     ? Center(
//                   child: SizedBox(
//                     width: 300.0,
//                     height: 600.0,
//                     child: MobileScanner(
//                       onError: (context, error) => Text(
//                         error.toString(),
//                         style: TextStyle(color: Colors.red),
//                       ),
//                       qrCodeCallback: (code) {
//                         setState(() {
//                           qr = code;
//                         });
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.transparent,
//                           border: Border.all(
//                               color: Colors.orange,
//                               width: 10.0,
//                               style: BorderStyle.solid),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//                     : Center(child: Text("Camera inactive"))),
//             Text("QRCODE: $qr"),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//           child: Text(
//             "press me",
//             textAlign: TextAlign.center,
//           ),
//           onPressed: () {
//             setState(() {
//               camState = !camState;
//             });
//           }),
//     );
//   }
// }