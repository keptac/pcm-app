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
import 'package:zeucpcm/widgets/customDialogs/meal_verification_dialog.dart';
import 'package:zeucpcm/widgets/customDialogs/signout_dialog.dart';
import 'package:zeucpcm/widgets/customDialogs/unverified_dialog.dart';
import 'package:zeucpcm/widgets/customDialogs/verification_dialog.dart';
import 'package:intl/intl.dart';

import '../model/meal_info.dart';

class MealController extends GetxController {
  dynamic username;
  RxBool scanning = false.obs;
  QRViewController? qrViewController;
  RxList<MealInfo> meal = RxList<MealInfo>();
  List<String> formattedDate = [];
  String reload = "yes";
  bool isFirst = true;
  // final MealControllerPut = Get.put(MealController());
  // final api = Api();

  void getSubscribers() async {
    meal.clear();
    List<MealInfo> delegates = await Api().getMealsSubscribers();

    MealInfo value;

    for (var delegate in delegates) {
      value = MealInfo(
        id: delegate.id,
        mealName: delegate.mealName,
        username: delegate.username,
        checkinStatus: delegate.checkinStatus,
      );
      scanning.value = false;
      formattedDate.add(DateFormat('kk:mm | EEE d MMM').format(DateTime.now()));
      meal.add(value);
    }
  }

  void getDelegates() async {
    meal.clear();
    List<MealInfo> delegates = await Api().getMealsSubscribers();

    MealInfo value;

    for (var delegate in delegates) {
      value = MealInfo(
        id: delegate.id,
        mealName: delegate.mealName,
        username: delegate.username,
        checkinStatus: delegate.checkinStatus,
      );
      scanning.value = false;
      formattedDate
          .add(DateFormat('kk:mm:ss | EEE d MMM').format(DateTime.now()));
      meal.add(value);
    }
  }

  String? extractPhoneNumber(String vcardData) {
    RegExp telRegExp = RegExp(r'TEL:(\d+)');
    Match telMatch = telRegExp.firstMatch(vcardData) as Match;
    return telMatch.group(1);
  }

  // Scanning to find checking in meal
  void findMealData(Barcode? zeucpcmResult, double height, double width) async {
    var variable = zeucpcmResult?.code;

    String? phoneNumber = extractPhoneNumber(variable.toString());

    var requestBody = <String, dynamic>{};
    var request = <String, dynamic>{};
    DateTime now = DateTime.now();
    String mealType = "";
    int hours = now.hour;

    if (hours >= 4 && hours <= 11) {
      mealType = "Breakfast";
    } else if (hours >= 12 && hours <= 15) {
      mealType = "Lunch";
    } else if (hours >= 16 && hours <= 23) {
      mealType = "Supper";
    }

    requestBody['id'] = phoneNumber.toString();
    requestBody['meal'] = mealType;
    requestBody['day'] = DateFormat('EEEE').format(DateTime.now());

    request['operation'] = "meal";
    request['requestBody'] = requestBody;

    var fullResponse;

    PCMServices.meals(request).then((response) {
      fullResponse = response.responseBody;

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
          var value = MealInfo(
            id: fullResponse['userMealId'],
            username: fullResponse['username'],
            mealName: fullResponse['mealName'],
            checkinStatus: fullResponse['checkinStatus'],
          );

          Api().insertMeal(value);
          verifiedDialog(height, width, value);
          update();
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
    meal.clear();
  }

  Future<void> verifiedDialog(
      double height, double width, MealInfo meal) async {
    getDelegates();
    await Get.dialog(
        MealVerificationDialog(height: height, width: width, meal: meal),
        barrierDismissible: false);
  }

  Future<void> alreadyVerifiedDialog(
      double height, double width, MealInfo meal) async {
    getDelegates();
    await Get.dialog(
        MealVerificationDialog(height: height, width: width, meal: meal),
        barrierDismissible: false);
  }

  void reset() {
    getDelegates();
    scanning.value = false;
  }

  void back() {
    Get.back();
    qrViewController?.resumeCamera();
  }
}
