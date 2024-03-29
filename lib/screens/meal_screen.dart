import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeucpcm/model/user_info.dart';
import 'package:zeucpcm/screens/login_screen.dart';
import 'package:zeucpcm/screens/qr_scanner.dart';
import 'package:zeucpcm/styles/app_colors.dart';
import 'package:zeucpcm/styles/app_styletext.dart';
import 'package:zeucpcm/utils/constants/size_constants.dart';
import 'package:zeucpcm/widgets/customDialogs/verification_dialog.dart';
import 'package:zeucpcm/widgets/user_tile.dart';
import 'package:get/get.dart';

import '../controllers/meal_controller.dart';
import '../model/meal_info.dart';
import '../widgets/customDialogs/meal_verification_dialog.dart';
import '../widgets/meal_tile.dart';
import 'meals_qr_controller.dart';
// import 'package:connectivity/connectivity.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({Key? key}) : super(key: key);

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> with TickerProviderStateMixin {
  final mealControllerPut = Get.put(MealController());
  String reload = "";

  Future<void> verifiedDialog(
      double height, double width, MealInfo meal) async {
    mealControllerPut.getSubscribers();
    await Get.dialog(
        MealVerificationDialog(height: height, width: width, meal: meal),
        barrierDismissible: false);
  }

  @override
  void initState() {
    mealControllerPut.getSubscribers();
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
            "MEAL CHECK-IN",
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
                      child: MealsScanner(),
                    ),

                    //Display a list of checkedIn Users

                    Padding(
                      padding: const EdgeInsets.all(Sizes.dimen_24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => mealControllerPut.meal.isEmpty
                                ? const Text(
                                    "No meal record as yet. ",
                                    style: AppStyleText.infoDetailR16S,
                                  )
                                :

                                //Gets delegates count
                                RichText(
                                    text: TextSpan(
                                      text: "Meal Checkin ",
                                      style: AppStyleText.infoDetailR16S,
                                      children: [
                                        TextSpan(
                                          text:
                                              "${mealControllerPut.meal.length}",
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
                        child: mealControllerPut.meal.isEmpty
                            ? const Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.list_rounded,
                                      color: AppColors.secondaryIconColor,
                                      size: 70,
                                    ),
                                    Text(
                                      'Scan QR to check in',
                                      style: AppStyleText.largeTitleR28,
                                    )
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: mealControllerPut.meal.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return MealTile(
                                      width: width,
                                      meal: mealControllerPut.meal[index],
                                      formattedDate: mealControllerPut
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
                  child: mealControllerPut.scanning.isTrue
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
