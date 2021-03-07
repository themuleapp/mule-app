import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:mule/config/app_theme.dart';

Widget button(String text, Function callback, double screenHeight, context) {
  return AnimatedOpacity(
    duration: const Duration(milliseconds: 500),
    opacity: 1.0,
    child: ProgressButton(
      defaultWidget: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: AppTheme.elementSize(
              screenHeight, 14, 15, 16, 17, 18, 26, 28, 30),
          letterSpacing: 0.0,
          color: AppTheme.white,
        ),
      ),
      progressWidget: CircularProgressIndicator(
          backgroundColor: AppTheme.white,
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.secondaryBlue)),
      width: MediaQuery.of(context).size.width,
      height:
          AppTheme.elementSize(screenHeight, 36, 38, 42, 48, 48, 48, 48, 48),
      color: AppTheme.lightBlue,
      borderRadius:
          AppTheme.elementSize(screenHeight, 8, 10, 12, 16, 16, 16, 16, 16),
      animate: true,
      type: ProgressButtonType.Raised,
      onPressed: () async {
        await Future.delayed(const Duration(milliseconds: 1000), () => 42);
        callback();
        //return {callback()};
      },
    ),
  );
}
