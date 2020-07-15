import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final double verticalPadding;
  final String value;
  final Icon suffixIcon;
  final bool showLabel;
  final bool obscureText;
  final Function validator;
  final TextInputType keyboardType;
  CustomTextFormField(
      {@required this.hintText,
      this.verticalPadding,
      this.controller,
      this.obscureText = false,
      this.value,
      this.keyboardType = TextInputType.text,
      this.suffixIcon,
      this.showLabel = true,
      this.validator});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          showLabel
              ? Text(
                  hintText.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: AppTheme.elementSize(
                        screenHeight, 13, 13, 13, 14, 14, 20, 24, 26),
                    color: AppTheme.lightGrey,
                  ),
                )
              : SizedBox(),
          SizedBox(
            height: AppTheme.elementSize(
                screenHeight, 7, 7, 7, 7, 7, 11, 14, 16),
          ),
          TextFormField(
            keyboardType: keyboardType,
            obscureText: obscureText,
            controller: controller,
            initialValue: value,
            validator: validator,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppTheme.elementSize(
                  screenHeight, 14, 14, 14, 15, 16, 23, 25, 28),
            ),
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                  vertical: verticalPadding != null ? verticalPadding : 10.0,
                  horizontal: 15.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppTheme.lightBlue,
                ),
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: AppTheme.elementSize(
                    screenHeight, 14, 15, 16, 17, 18, 20, 24, 28),
                color: AppTheme.lightGrey.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
