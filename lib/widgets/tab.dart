import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';

Widget tab(tabTitle, screenHeight) {
  return Container(
    height: 30,
    child: Text(
      tabTitle,
      style: TextStyle(
        fontFamily: AppTheme.fontName,
        fontWeight: FontWeight.w500,
        fontSize: AppTheme.elementSize(screenHeight,
            14, 15, 16, 17, 18, 20, 24, 28),
      ),
    ),
  );
}