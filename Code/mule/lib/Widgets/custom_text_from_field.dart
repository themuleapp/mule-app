import 'package:flutter/material.dart';
import 'package:mule/config/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final double verticalPadding;
  final String value;
  final Icon suffixIcon;
  final bool showLabel;
  final bool obsecureText;
  CustomTextFormField(
      {@required this.hintText,
      this.verticalPadding,
      this.controller,
      this.obsecureText = false,
      this.value,
      this.suffixIcon,
      this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          showLabel
              ? Text(
                  hintText.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                    color: AppColors.lightGrey,
                  ),
                )
              : SizedBox(),
          SizedBox(
            height: 7.0,
          ),
          TextFormField(
            obscureText: obsecureText,
            controller: controller,
            initialValue: value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                  vertical: verticalPadding != null ? verticalPadding : 10.0,
                  horizontal: 15.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[400],
                ),
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
