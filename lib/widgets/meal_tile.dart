import 'package:flutter/material.dart';
import 'package:zeucpcm/model/user_info.dart';
import 'package:zeucpcm/styles/app_colors.dart';
import 'package:zeucpcm/styles/app_styletext.dart';
import 'package:zeucpcm/utils/constants/size_constants.dart';
import 'package:intl/intl.dart';

import '../model/meal_info.dart';

class MealTile extends StatelessWidget {
  const MealTile(
      {Key? key,
      required this.width,
      required this.meal,
      required this.formattedDate})
      : super(key: key);

  final double width;
  final MealInfo meal;
  final String formattedDate;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      height: 76,
      width: width * 0.65,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(Sizes.dimen_12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.username,
                        style: AppStyleText.largeTitleM18P,
                      ),
                      Text(
                        meal.mealName,
                        style: AppStyleText.infoDetailR16S,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(meal.mealName, style: AppStyleText.infoDetailR16D7),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
