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
import 'package:zeucpcm/screens/login_screen.dart';
import 'package:zeucpcm/screens/qr_scanner.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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

  @override
  void initState() {
    homeControllerPut.getDelegates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          // toolbarHeight: 2,
          backgroundColor: const Color.fromARGB(255, 121, 10, 10),
          elevation: 5.0,
          titleSpacing: 00.0,
          centerTitle: true,
          title: const Text(
            "Miscon Checkin",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          leading: BackButton(
            color: Colors.white,
            onPressed: () => {Navigator.pop(context)},
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onSelected: (value) {},
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                      child: const Text("Logout"),
                      value: "Logout",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LogInScreen()));
                      }),
                ];
              },
            )
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.scaffoldBackgroundColor,
                body: Column(
                  children: [
                    //Scanner
                    const SizedBox(
                      width: 400,
                      height: 300,
                      child: zeucpcmScanner(),
                    ),

                    //Display a list of checkedIn Users

                    Padding(
                      padding: const EdgeInsets.all(Sizes.dimen_24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => homeControllerPut.user.isEmpty
                                ? const Text(
                                    "No user checked in yet on your device",
                                    style: AppStyleText.infoDetailR16S,
                                  )
                                :

                                //Gets delegates count
                                RichText(
                                    text: TextSpan(
                                      text: "Checked In Attendees",
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
                                itemBuilder: (BuildContext context, int index) {
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
        ));
  }
}
