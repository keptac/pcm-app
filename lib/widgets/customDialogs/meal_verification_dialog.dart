import 'package:flutter/material.dart';
import 'package:zeucpcm/controllers/home_controller.dart';
import 'package:zeucpcm/model/user_info.dart';
import 'package:zeucpcm/styles/app_colors.dart';
import 'package:zeucpcm/styles/app_styletext.dart';
import 'package:zeucpcm/utils/constants/size_constants.dart';
import 'package:get/get.dart';

import '../../model/meal_info.dart';

class MealVerificationDialog extends StatelessWidget {
  MealVerificationDialog({
    Key? key,
    required this.height,
    required this.width,
    required this.meal,
  }) : super(key: key);

  final double height;
  final double width;
  final MealInfo meal;
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      backgroundColor: AppColors.dialogBoxColor,
      child: SizedBox(
        height: height * 0.38,
        width: width * 0.31,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                    onTap: () {
                      homeController.back();
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.white,
                      size: Sizes.dimen_24,
                    )),
              ),
            ),
            Text(
              meal.username,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              "Checked in for " + meal.mealName,
              textAlign: TextAlign.center,
              style: AppStyleText.infoDetailR16W4,
            ),
            Text(
              meal.checkinStatus,
              textAlign: TextAlign.center,
              style: AppStyleText.infoDetailR16W4,
            ),
            Container(
              alignment: Alignment.center,
              width: width,
              height: height * 0.08,
              decoration: const BoxDecoration(
                  color: AppColors.butttoColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: const Text(
                'Success',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: AppColors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
