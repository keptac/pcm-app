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
  final TextEditingController emailController = TextEditingController();

  String get firstname => firstnameController.text.trim();
  String get lastname => lastnameController.text.trim();
  String get companyname => companynameController.text.trim();
  String get email => emailController.text.trim();

  final obsecureText = true.obs;

  final Api api = Api();
  late List<User> users;
  dynamic result;

  void login(BuildContext context) {
    var updatedDelegate = DelegateInfo(
        id: 93343,
        fname: firstname,
        lname: lastname,
        username: companyname,
        email: email,
        image: 'image',
        checkinStatus: 1);

    print(updatedDelegate.toString);

    var value = UserInfo(
      id: updatedDelegate.id,
      fname: updatedDelegate.fname,
      lname: updatedDelegate.lname,
      username: updatedDelegate.username,
      email: updatedDelegate.email,
      image: updatedDelegate.image,
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
    Get.snackbar('Failed', "Password or Email is wrong",
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
    Get.offNamed('/home');
  }

  void setObsecureText(bool value) {
    obsecureText.value = value;
  }
}
