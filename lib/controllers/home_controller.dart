import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:zeucpcm/model/delegate_info.dart';
import 'package:zeucpcm/model/user_info.dart';
import 'package:zeucpcm/model/user_role.dart';
import 'package:zeucpcm/services/api.dart';
import 'package:zeucpcm/services/pcm_services.dart';
import 'package:zeucpcm/widgets/customDialogs/already_checked_dialog.dart';
import 'package:zeucpcm/widgets/customDialogs/create_user_dialog.dart';
import 'package:zeucpcm/widgets/customDialogs/signout_dialog.dart';
import 'package:zeucpcm/widgets/customDialogs/unverified_dialog.dart';
import 'package:zeucpcm/widgets/customDialogs/verification_dialog.dart';
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
        title: delegate.title,
        institute: delegate.institute,
        username: delegate.username,
        selectedRoom: delegate.selectedRoom,
        checkinStatus: delegate.checkinStatus,
        roleId: 1,
        userRole: UserRole(
            id: 1,
            name: "Delegate",
            slug: "Our highly esteemed delegate",
            status: 1),
      );
      scanning.value = false;
      formattedDate.add(DateFormat('kk:mm | EEE d MMM').format(DateTime.now()));
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
        title: delegate.title,
        institute: delegate.institute,
        username: delegate.username,
        selectedRoom: delegate.selectedRoom,
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
      Barcode? zeucpcmResult, double height, double width) async {
    var userId = zeucpcmResult?.code;

    List<DelegateInfo> delegate =
        await Api().getDelegateById(userId.toString());

    if (delegate.isNotEmpty) {
      var value = UserInfo(
        id: delegate[0].id,
        title: delegate[0].title,
        institute: delegate[0].institute,
        username: delegate[0].username,
        selectedRoom: delegate[0].selectedRoom,
        checkinStatus: delegate[0].checkinStatus,
        roleId: 1,
        userRole: UserRole(
            id: 1,
            name: delegate[0].title,
            slug: "Our highly esteemed delegate",
            status: 1),
      );

      var updatedDelegate = DelegateInfo(
          id: delegate[0].id,
          title: delegate[0].title,
          institute: delegate[0].institute,
          username: delegate[0].username,
          selectedRoom: delegate[0].selectedRoom,
          checkinStatus: "CHECKED IN");

      await Api().subscribeUser(updatedDelegate);
      verifiedDialog(height, width, value);
      update();
    }

    scanning.value = false;
  }

  String? extractPhoneNumber(String vcardData) {
    RegExp telRegExp = RegExp(r'TEL:(\d+)');
    Match telMatch = telRegExp.firstMatch(vcardData) as Match;
    return telMatch.group(1);
  }

  // Scanning to find checking in user
  void setQRUrl(Barcode? zeucpcmResult, double height, double width) async {
    var variable = zeucpcmResult?.code;

    String? phoneNumber = extractPhoneNumber(variable.toString());

    var requestBody = <String, dynamic>{};
    var request = <String, dynamic>{};

    requestBody['phoneNumber'] = phoneNumber.toString();
    request['operation'] = "checking";
    request['requestBody'] = requestBody;

    var fullResponse;

    PCMServices.checkin(request).then((response) {
      fullResponse = response.responseBody["user"];

      if (response.success == true) {
        Get.snackbar(
          'Success',
          response.responseBody['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(190, 113, 50, 223),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          colorText: Colors.white,
        );

        if (fullResponse.isNotEmpty) {
          var value = UserInfo(
            id: fullResponse['_id'],
            username: fullResponse['username'],
            title: fullResponse['title'],
            institute: fullResponse['institute'],
            selectedRoom: fullResponse['selectedRoom'],
            checkinStatus: fullResponse['checkinStatus'],
            roleId: 1,
            userRole: UserRole(
                id: 1,
                name: "Delegate",
                slug: "Our highly esteemed delegate",
                status: 1),
          );

          if (fullResponse['checkinStatus'] != "CHECKED IN") {
            alreadyVerifiedDialog(height, width, value);
          } else {
            var updatedDelegate = DelegateInfo(
              id: fullResponse['_id'],
              username: fullResponse['username'],
              title: fullResponse['title'],
              institute: fullResponse['institute'],
              selectedRoom: fullResponse['selectedRoom'],
              checkinStatus: fullResponse['checkinStatus'],
            );

            Api().insertDelegate(updatedDelegate);
            verifiedDialog(height, width, value);

            update();

            // Navigator.popAndPushNamed(context, '/home');
            //
          }
        }
      } else {
        Get.snackbar(
          'Error',
          response.responseBody['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(190, 2, 0, 0),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          colorText: Colors.white,
        );
      }
    });

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

  // Future<void> createUserDialog(double height, double width) async {
  //   CreateUserDialog(height: height, width: width);
  // }

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
