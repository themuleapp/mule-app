import 'package:flutter/material.dart';
//show Color, Colors;

class AppTheme {
  AppTheme._();

  //Colors
  static final Color white = Color(0xFFFFFFFF);
  static final Color black = Color(0xFF000000);

  static final Color lightSkyBlue = Color(0xFFEDFCFF);

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

//  static const TextTheme textTheme = TextTheme(
//    headline4: display1,
//    headline5: headline,
//    headline6: title,
//    subtitle2: subtitle,
//    bodyText2: body2,
//    bodyText1: body1,
//    caption: caption,
//  );
//
//  static const TextStyle display1 = TextStyle( // h4 -> display1
//    fontFamily: fontName,
//    fontWeight: FontWeight.bold,
//    fontSize: 36,
//    letterSpacing: 0.4,
//    height: 0.9,
//    color: darkerText,
//  );
//
//  static const TextStyle headline = TextStyle( // h5 -> headline
//    fontFamily: fontName,
//    fontWeight: FontWeight.bold,
//    fontSize: 24,
//    letterSpacing: 0.27,
//    color: darkerText,
//  );
//
//  static const TextStyle title = TextStyle( // h6 -> title
//    fontFamily: fontName,
//    fontWeight: FontWeight.bold,
//    fontSize: 16,
//    letterSpacing: 0.18,
//    color: darkerText,
//  );
//
//  static const TextStyle subtitle = TextStyle( // subtitle2 -> subtitle
//    fontFamily: fontName,
//    fontWeight: FontWeight.w400,
//    fontSize: 14,
//    letterSpacing: -0.04,
//    color: darkText,
//  );
//
//  static const TextStyle body2 = TextStyle( // body1 -> body2
//    fontFamily: fontName,
//    fontWeight: FontWeight.w400,
//    fontSize: 14,
//    letterSpacing: 0.2,
//    color: darkText,
//  );
//
//  static const TextStyle body1 = TextStyle( // body2 -> body1
//    fontFamily: fontName,
//    fontWeight: FontWeight.w400,
//    fontSize: 16,
//    letterSpacing: -0.05,
//    color: darkText,
//  );
//
//  static const TextStyle caption = TextStyle( // Caption -> caption
//    fontFamily: fontName,
//    fontWeight: FontWeight.w400,
//    fontSize: 12,
//    letterSpacing: 0.2,
//    color: lightText, // was lightText
//  );
}
