import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeucpcm/controllers/home_controller.dart';
import 'package:zeucpcm/main.dart';
import 'package:zeucpcm/model/delegate_info.dart';
import 'package:zeucpcm/model/user_info.dart';
import 'package:zeucpcm/model/user_role.dart';
import 'package:zeucpcm/screens/initialization_screen.dart';
import 'package:zeucpcm/screens/qr_scanner.dart';
import 'package:zeucpcm/screens/qr_scanner_subscribe.dart';
import 'package:zeucpcm/services/api.dart';
import 'package:zeucpcm/styles/app_colors.dart';
import 'package:zeucpcm/styles/app_styletext.dart';
import 'package:zeucpcm/utils/constants/size_constants.dart';
import 'package:zeucpcm/widgets/customDialogs/create_user_dialog.dart';
import 'package:zeucpcm/widgets/customDialogs/verification_dialog.dart';
import 'package:zeucpcm/widgets/custom_button.dart';
import 'package:zeucpcm/widgets/k_inputfield.dart';
import 'package:zeucpcm/widgets/user_tile.dart';
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
  final TextEditingController selectedRoomController = TextEditingController();

  Future<void> verifiedDialog(
      double height, double width, UserInfo user) async {
    homeControllerPut.getDelegates();
    await Get.dialog(
        VerificationDialog(height: height, width: width, user: user),
        barrierDismissible: false);
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
              hintText: "selectedRoom Address",
              prefixIcon: const SizedBox(),
              suffixIcon: const SizedBox(),
              textInputType: TextInputType.text,
              controller: selectedRoomController,
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
                    // subscribeUser(context);
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
                const Expanded(child: zeucpcmScannerSubscribe()),

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
