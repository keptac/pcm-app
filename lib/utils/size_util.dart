import 'package:flutter/cupertino.dart';

class SizeUtil{
  static double width(context, double value){
    return MediaQuery.sizeOf(context).width * value;
  }

  static double height(context, double value){
    return MediaQuery.sizeOf(context).height * value;
  }
}