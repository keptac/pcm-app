import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeucpcm/helper/shared_preferences.dart';
import 'package:zeucpcm/model/delegate_info.dart';
import 'package:zeucpcm/model/user.dart';
import 'package:zeucpcm/model/user_info.dart';
import 'package:zeucpcm/model/user_role.dart';
import 'package:zeucpcm/services/api.dart';
import 'package:zeucpcm/styles/app_colors.dart';
import 'package:connectivity/connectivity.dart';
import 'package:zeucpcm/widgets/customDialogs/verification_dialog.dart';

class CreateUserController extends GetxController {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController companynameController = TextEditingController();
  final TextEditingController selectedRoomController = TextEditingController();

  String get firstname => firstnameController.text.trim();
  String get lastname => lastnameController.text.trim();
  String get companyname => companynameController.text.trim();
  String get selectedRoom => selectedRoomController.text.trim();

  final obsecureText = true.obs;

  final Api api = Api();
  late List<User> users;
  dynamic result;

  void login(BuildContext context) {
    var updatedDelegate = DelegateInfo(
        id: "93343",
        title: firstname,
        institute: lastname,
        username: companyname,
        selectedRoom: selectedRoom,
        checkinStatus: "CHECKED IN");

    print(updatedDelegate.toString);

    var value = UserInfo(
      id: updatedDelegate.id,
      title: updatedDelegate.title,
      institute: updatedDelegate.institute,
      username: updatedDelegate.username,
      selectedRoom: updatedDelegate.selectedRoom,
      checkinStatus: updatedDelegate.checkinStatus,
      roleId: 1,
      userRole: UserRole(
          id: 1,
          name: "Delegate",
          slug: "Our highly esteemed delegate",
          status: 1),
    );

    verifiedDialog(200, 200, value);
    Api().insertDelegate(updatedDelegate);
    update();
  }

  Future<void> verifiedDialog(
      double height, double width, UserInfo user) async {
    await Get.dialog(
        VerificationDialog(height: height, width: width, user: user),
        barrierDismissible: false);
  }

  void authFailed(BuildContext context) {
    Get.snackbar('Failed', "Password or selectedRoom is wrong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        margin: const EdgeInsets.all(16),
        isDismissible: true,
        colorText: Colors.white,
        maxWidth: MediaQuery.of(context).size.width * 0.4);
  }

  void authSuccess(BuildContext context) {
    SharedPreferenceHelper.saveUserLoggedInSharedPreference(true);
    Get.snackbar('Success', "Sign in Sccessfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primaryColor,
        margin: const EdgeInsets.all(16),
        isDismissible: true,
        colorText: Colors.white,
        maxWidth: MediaQuery.of(context).size.width * 0.35);
    Get.off('/home');
  }

  void setObsecureText(bool value) {
    obsecureText.value = value;
  }
}
