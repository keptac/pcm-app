import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:get/get.dart';
import 'package:zeucpcm/controllers/home_controller.dart';
import 'package:zeucpcm/controllers/meal_controller.dart';

class MealsScanner extends StatefulWidget {
  const MealsScanner({Key? key}) : super(key: key);

  @override
  _MealsScannerState createState() => _MealsScannerState();
}

class _MealsScannerState extends State<MealsScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final mealsController = Get.find<MealController>();
  double height = 500;
  double width = 500;

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application Permissions not granted')),
      );
    }
  }

  void _doNothing(QRViewController controller) {
    print('stopped');
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  void _onzeucpcmReading(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      mealsController.setQRViewController(controller);
      mealsController.setScanning(true);
      mealsController.findMealData(scanData, height, width);
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    var scanArea = (width < 400 || height < 400) ? 150.0 : 300.0;
    return SizedBox(
        height: height,
        width: width * 0.3,
        child: QRView(
          key: qrKey,
          onQRViewCreated:
              mealsController.scanning.isTrue ? _doNothing : _onzeucpcmReading,
          cameraFacing: CameraFacing.back,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ));
  }
}
