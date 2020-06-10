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
                    color: AppTheme.lightGrey,
                  ),
                )
              : SizedBox(),
          SizedBox(
            height: 7.0,
          ),
          TextFormField(
            keyboardType: keyboardType,
            obscureText: obscureText,
            controller: controller,
            initialValue: value,
            validator: validator,
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
