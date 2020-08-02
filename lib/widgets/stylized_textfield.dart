import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';

class StylizedTextField extends StatelessWidget {
  double screenHeight;
  TextEditingController controller;

  StylizedTextField({@required this.screenHeight, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 32, right: 32),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                offset: const Offset(4, 4),
                blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 160),
            color: AppTheme.white,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              child: TextField(
                controller: controller,
                maxLines: null,
                onChanged: (String txt) {},
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 16,
                  color: AppTheme.darkGrey,
                ),
                cursorColor: AppTheme.lightBlue,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your feedback...',
                  hintStyle: TextStyle(
                    fontSize: AppTheme.elementSize(
                        screenHeight, 14, 15, 16, 17, 18, 20, 24, 26),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _customTextField(double screenHeight) {}
