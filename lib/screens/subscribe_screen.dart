import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrcode/controllers/home_controller.dart';
import 'package:qrcode/main.dart';
import 'package:qrcode/model/delegate_info.dart';
import 'package:qrcode/model/user_info.dart';
import 'package:qrcode/model/user_role.dart';
import 'package:qrcode/screens/initialization_screen.dart';
import 'package:qrcode/screens/qr_scanner.dart';
import 'package:qrcode/screens/qr_scanner_subscribe.dart';
import 'package:qrcode/services/api.dart';
import 'package:qrcode/styles/app_colors.dart';
import 'package:qrcode/styles/app_styletext.dart';
import 'package:qrcode/utils/constants/size_constants.dart';
import 'package:qrcode/widgets/customDialogs/create_user_dialog.dart';
import 'package:qrcode/widgets/customDialogs/verification_dialog.dart';
import 'package:qrcode/widgets/custom_button.dart';
import 'package:qrcode/widgets/k_inputfield.dart';
import 'package:qrcode/widgets/user_tile.dart';
import 'package:get/get.dart';
// import 'package:connectivity/connectivity.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({Key? key}) : super(key: key);

  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen>
    with TickerProviderStateMixin {
  final homeControllerPut = Get.put(HomeController());
  String reload = "";

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController companynameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> verifiedDialog(
      double height, double width, UserInfo user) async {
    homeControllerPut.getDelegates();
    await Get.dialog(
        VerificationDialog(height: height, width: width, user: user),
        barrierDismissible: false);
  }

  void subscribeUser(BuildContext context) {
    Random random = Random();
    int min = 1000000; // Minimum 7-digit number (1,000,000)
    int max = 9999999; // Maximum 7-digit number (9,999,999)
    int randomId = min + random.nextInt(max - min);
    var updatedDelegate = DelegateInfo(
        id: randomId,
        fname: firstnameController.text,
        lname: lastnameController.text,
        username: companynameController.text,
        email: emailController.text,
        image: 'image',
        checkinStatus: 1);

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
    firstnameController.clear();
    lastnameController.clear();
    companynameController.clear();
    emailController.clear();

    Api().subscribeUser(updatedDelegate);
    Navigator.popAndPushNamed(context, '/subscribe');

    verifiedDialog(500, 500, value);
  }

  @override
  void initState() {
    homeControllerPut.getSubscribers();
    super.initState();
  }

  Widget createDialog(height, width) {
    return SizedBox(
      height: height * 0.55,
      width: width * 0.42,
      child: ListView(
        children: [
          const SizedBox(height: 50),
          KInputField(
              width: width * 0.42,
              hintText: "First Name",
              prefixIcon: const SizedBox(),
              suffixIcon: const SizedBox(),
              textInputType: TextInputType.text,
              controller: firstnameController,
              hintTextStyle: AppStyleText.infoDetailM16S5,
              textStyle: AppStyleText.infoDetailM16P5,
              suffixText: ''),
          const SizedBox(height: 22),
          KInputField(
              width: width * 0.42,
              hintText: "Surname",
              prefixIcon: const SizedBox(),
              suffixIcon: const SizedBox(),
              textInputType: TextInputType.text,
              controller: lastnameController,
              hintTextStyle: AppStyleText.infoDetailM16S5,
              textStyle: AppStyleText.infoDetailM16P5,
              suffixText: ''),
          const SizedBox(height: 22),
          KInputField(
              width: width * 0.42,
              hintText: "Email Address",
              prefixIcon: const SizedBox(),
              suffixIcon: const SizedBox(),
              textInputType: TextInputType.text,
              controller: emailController,
              hintTextStyle: AppStyleText.infoDetailM16S5,
              textStyle: AppStyleText.infoDetailM16P5,
              suffixText: ''),
          const SizedBox(height: 22),
          KInputField(
              width: width * 0.42,
              hintText: "Company",
              prefixIcon: const SizedBox(),
              suffixIcon: const SizedBox(),
              textInputType: TextInputType.text,
              controller: companynameController,
              hintTextStyle: AppStyleText.infoDetailM16S5,
              textStyle: AppStyleText.infoDetailM16P5,
              suffixText: ''),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomRaisedBtn(
                  onPressed: () {
                    subscribeUser(context);
                    // Get.back();
                  },
                  borderRadius: Sizes.dimen_18,
                  width: width * 0.15,
                  height: Sizes.dimen_42,
                  child: const Text(
                    'Add',
                    style: AppStyleText.buttonSM20W5,
                  ),
                  color: AppColors.butttoColor),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.scaffoldBackgroundColor,
            body: Row(
              children: [
                //Scanner
                const Expanded(child: QRCodeScannerSubscribe()),

                //Display a list of checkedIn Users
                SizedBox(
                  height: height,
                  width: width * 0.7,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Sizes.dimen_24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => homeControllerPut.user.isEmpty
                                  ? const Text(
                                      "No subscriptions yet",
                                      style: AppStyleText.infoDetailR16S,
                                    )
                                  :

                                  //Gets delegates count
                                  RichText(
                                      text: TextSpan(
                                        text: "Subscribed Delegates",
                                        style: AppStyleText.infoDetailR16S,
                                        children: [
                                          TextSpan(
                                            text:
                                                "${homeControllerPut.user.length}",
                                            style: AppStyleText.infoDetailR16D7,
                                          )
                                        ],
                                      ),
                                    ),
                            ),

                            //Capture button
                            CustomRaisedBtn(
                                borderRadius: Sizes.dimen_12,
                                onPressed: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Subscribe Delegate'),
                                        content: createDialog(height, width),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      ),
                                    ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Sizes.dimen_16),
                                  child: Text(
                                    'Subscribe delegate',
                                    style: AppStyleText.largeTitleM18W,
                                  ),
                                ),
                                color: const Color.fromARGB(255, 0, 61, 2),
                                width: 250,
                                height: Sizes.dimen_42),
                          ],
                        ),
                      ),

                      //DISPLAYS DELEGATES CHECKED IN
                      Obx(
                        () => Expanded(
                          child: homeControllerPut.user.isEmpty
                              ? const Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.list_rounded,
                                        color: AppColors.secondaryIconColor,
                                        size: 80,
                                      ),
                                      Text(
                                        'Scan QR to check in',
                                        style: AppStyleText.largeTitleR28,
                                      )
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: homeControllerPut.user.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return UserTile(
                                        width: width,
                                        user: homeControllerPut.user[index],
                                        formattedDate: homeControllerPut
                                            .formattedDate[index]);
                                  },
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          //Widgets displayed when scanning is in progress
          Obx(() => Center(
              child: homeControllerPut.scanning.isTrue
                  ? Container(
                      width: width,
                      height: height,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(Sizes.dimen_16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            spreadRadius: 5,
                            blurRadius: 3,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Scanning!',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.subTitleTextColor,
                                decoration: TextDecoration.none),
                          ),
                          SizedBox(height: 16),
                          CupertinoActivityIndicator(),
                          SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Please wait',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.subTitleTextColor,
                                decoration: TextDecoration.none),
                          )
                        ],
                      ),
                    )
                  : const SizedBox())),
        ],
      ),
    );
  }
}
