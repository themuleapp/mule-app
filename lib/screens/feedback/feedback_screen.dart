import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/widgets/full_page_screen.dart';
import 'package:mule/widgets/stylized_textfield.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return FullPageScreen(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Image.asset(
            'assets/images/feedback.png',
            height: screenHeight * 0.45,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 25),
          child: Text(
            'Any thoughts or suggestions?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppTheme.elementSize(
                  screenHeight, 20, 21, 22, 23, 25, 27, 28, 30),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            'We would love to hear from you',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppTheme.elementSize(
                  screenHeight, 14, 15, 16, 18, 19, 20, 22, 24),
            ),
          ),
        ),
        StylizedTextField(
          screenHeight: screenHeight,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Container(
              width: AppTheme.elementSize(
                  screenHeight, 120, 130, 140, 150, 160, 180, 200, 220),
              height: AppTheme.elementSize(
                  screenHeight, 40, 40, 45, 45, 45, 50, 50, 50),
              decoration: BoxDecoration(
                color: AppTheme.lightBlue,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      offset: const Offset(4, 4),
                      blurRadius: 8.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'Send',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: AppTheme.elementSize(
                              screenHeight, 14, 15, 15, 17, 19, 21, 22, 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
