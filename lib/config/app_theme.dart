import 'package:flutter/material.dart';
//show Color, Colors;

class AppTheme {
  AppTheme._();

  //Colors
  static final Color white = Color(0xFFFFFFFF);
  static final Color black = Color(0xFF000000);

  static final Color lightSkyBlue = Color(0xFFEDFCFF);
  static final Color goldenYellow = Color (0xFFFFDF00);

  //static final Color lightBlue = Color(0xFF82EDFF);
  static final Color lightBlue = Color(0xFF6CD1E7);
  static final Color secondaryBlue = Color(0xFF019ABC);
  static final Color darkBlue = Color(0xFF003A6A);

  static final Color facebookBlue = Color(0xFF3B5998);
  static final Color menuBlue = Color(0xFF292E39);

  static final Color lightGrey = Color(0xFF808080);
  static final Color darkGrey = Color(0xFF404040);
  static final Color darkestGrey = Color(0xFF262626);

  static const Color lightText = Color(0xFF4A6572);
  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);

  //Fonts
  static const String fontName = 'ProximaNova';

  //Widget Sizes
  static double elementSize(
      double screenHeight,
      double xxxSmall,
      double xxSmall,
      double xSmall,
      double small,
      double medium,
      double xMedium,
      double large,
      double xLarge) {
    if (screenHeight <= 569)
      return xxxSmall;
    else if (screenHeight <= 667)
      return xxSmall;
    else if (screenHeight < 812)
      return xSmall;
    else if (screenHeight <= 853)
      return small;
    else if (screenHeight <= 960)
      return medium;
    else if (screenHeight <= 1024)
      return xMedium;
    else if (screenHeight <= 1280)
      return large;
    else
      return xLarge;
  }

  //Heading 1: screenHeight, 24, 26, 28, 30, 32, 40, 45, 50
  //Heading 2: screenHeight, 14, 15, 16, 17, 18, 20, 24, 28
  //Button 1: screenHeight, 36, 38, 40, 42, 45, 56, 62, 70
  //Button 1 Text: screenHeight, 14, 15, 16, 17, 18, 26, 28, 30
}
