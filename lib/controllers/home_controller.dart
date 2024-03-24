import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode/model/delegate_info.dart';
import 'package:qrcode/model/user_info.dart';
import 'package:qrcode/model/user_role.dart';
import 'package:qrcode/services/api.dart';
import 'package:qrcode/widgets/customDialogs/already_checked_dialog.dart';
import 'package:qrcode/widgets/customDialogs/create_user_dialog.dart';
import 'package:qrcode/widgets/customDialogs/signout_dialog.dart';
import 'package:qrcode/widgets/customDialogs/unverified_dialog.dart';
import 'package:qrcode/widgets/customDialogs/verification_dialog.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  dynamic username;
  RxBool scanning = false.obs;
  QRViewController? qrViewController;
  RxList<UserInfo> user = RxList<UserInfo>();
  List<String> formattedDate = [];
  String reload = "yes";
  bool isFirst = true;
  // final homeControllerPut = Get.put(HomeController());
  // final api = Api();

  void getSubscribers() async {
    user.clear();
    List<DelegateInfo> delegates = await Api().getAllSubscribers();

    UserInfo value;

    for (var delegate in delegates) {
      value = UserInfo(
        id: delegate.id,
        fname: delegate.fname,
        lname: delegate.lname,
        username: delegate.username,
        email: delegate.email,
        image: delegate.image,
        checkinStatus: delegate.checkinStatus,
        roleId: 1,
        userRole: UserRole(
            id: 1,
            name: "Delegate",
            slug: "Our highly esteemed delegate",
            status: 1),
      );
      scanning.value = false;
      formattedDate
          .add(DateFormat('kk:mm:ss | EEE d MMM').format(DateTime.now()));
      user.add(value);
    }
  }

  void getDelegates() async {
    user.clear();
    List<DelegateInfo> delegates = await Api().getAllCheckinDelegates();

    UserInfo value;

    for (var delegate in delegates) {
      value = UserInfo(
        id: delegate.id,
        fname: delegate.fname,
        lname: delegate.lname,
        username: delegate.username,
        email: delegate.email,
        image: delegate.image,
        checkinStatus: delegate.checkinStatus,
        roleId: 1,
        userRole: UserRole(
            id: 1,
            name: "Delegate",
            slug: "Our highly esteemed delegate",
            status: 1),
      );
      scanning.value = false;
      formattedDate
          .add(DateFormat('kk:mm:ss | EEE d MMM').format(DateTime.now()));
      user.add(value);
    }
  }

  // Scanning to find checking in user
  void setSubscribersQRUrl(
      Barcode? qrCodeResult, double height, double width) async {
    var userId = qrCodeResult?.code;

    List<DelegateInfo> delegate =
        await Api().getDelegateById(int.parse(userId.toString()));

    if (delegate.isNotEmpty) {
      var value = UserInfo(
        id: delegate[0].id,
        fname: delegate[0].fname,
        lname: delegate[0].lname,
        username: delegate[0].username,
        email: delegate[0].email,
        image: delegate[0].image,
        checkinStatus: delegate[0].checkinStatus,
        roleId: 1,
        userRole: UserRole(
            id: 1,
            name: "Delegate",
            slug: "Our highly esteemed delegate",
            status: 1),
      );

      var updatedDelegate = DelegateInfo(
          id: delegate[0].id,
          fname: delegate[0].fname,
          lname: delegate[0].lname,
          username: delegate[0].username,
          email: delegate[0].email,
          image: delegate[0].image,
          checkinStatus: 1);

      await Api().subscribeUser(updatedDelegate);
      verifiedDialog(height, width, value);
      update();
    }

    scanning.value = false;
  }

  // Scanning to find checking in user
  void setQRUrl(Barcode? qrCodeResult, double height, double width) async {
    var userId = qrCodeResult?.code;

    List<DelegateInfo> delegate =
        await Api().getDelegateById(int.parse(userId.toString()));

    if (delegate.isNotEmpty) {
      var value = UserInfo(
        id: delegate[0].id,
        fname: delegate[0].fname,
        lname: delegate[0].lname,
        username: delegate[0].username,
        email: delegate[0].email,
        image: delegate[0].image,
        checkinStatus: delegate[0].checkinStatus,
        roleId: 1,
        userRole: UserRole(
            id: 1,
            name: "Delegate",
            slug: "Our highly esteemed delegate",
            status: 1),
      );

      if (delegate[0].checkinStatus == 1) {
        alreadyVerifiedDialog(height, width, value);
      } else {
        var updatedDelegate = DelegateInfo(
            id: delegate[0].id,
            fname: delegate[0].fname,
            lname: delegate[0].lname,
            username: delegate[0].username,
            email: delegate[0].email,
            image: delegate[0].image,
            checkinStatus: 1);

        await Api().updateDelegateAttendance(updatedDelegate);
        // Navigator.popAndPushNamed(context, '/home');
        verifiedDialog(height, width, value);
        update();
      }
    } else {
      var updatedDelegate = const DelegateInfo(
          id: 93343,
          fname: 'GUEST',
          lname: 'USER',
          username: 'KEPTAC',
          email: 'guest@zeucpcm.org',
          image: 'image',
          checkinStatus: 1);

      Api().insertDelegate(updatedDelegate);
      unVerifiedDialog(height, width);
      update();
    }
    scanning.value = false;
  }

  void setQRViewController(QRViewController? controller) {
    qrViewController = controller;
    update();
  }

  void setScanning(dynamic value) {
    scanning.value = value;
  }

  void resetUserList() {
    user.clear();
  }

  Future<void> createUserDialog(double height, double width) async {
    CreateUserDialog(height: height, width: width);
  }

  Future<void> signOutDialog(double height, double width) async {
    await Get.dialog(SignOutDialog(height: height, width: width));
  }

  Future<void> unVerifiedDialog(double height, double width) async {
    getDelegates();
    await Get.dialog(
      UnverifiedDialog(height: height, width: width),
      barrierDismissible: false,
    );
  }

  Future<void> verifiedDialog(
      double height, double width, UserInfo user) async {
    getDelegates();
    await Get.dialog(
        VerificationDialog(height: height, width: width, user: user),
        barrierDismissible: false);
  }

  Future<void> alreadyVerifiedDialog(
      double height, double width, UserInfo user) async {
    getDelegates();
    await Get.dialog(
        AlreadyCheckedDialog(height: height, width: width, user: user),
        barrierDismissible: false);
  }

  void reset() {
    getDelegates();
    scanning.value = false;
    unVerifiedDialog(860, 1440);
  }

  void back() {
    Get.back();
    qrViewController?.resumeCamera();
  }
}
