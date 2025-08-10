import 'package:flutter/material.dart';

class SizeUtils {
  static late double screenWidth;
  static late double screenHeight;
  static late bool isMobile;

  static late double relativeScreenWidth;
  static late double relativeScreenHeight;

  void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    isMobile = MediaQuery.of(context).size.width < 600;
    relativeScreenWidth = SizeUtils.screenWidth / 393;
    relativeScreenHeight = SizeUtils.screenHeight / 852;
  }
}
