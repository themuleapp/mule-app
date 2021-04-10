import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/navigation_home_screen.dart';
import 'package:mule/widgets/button.dart';
import 'package:mule/widgets/unordered_list.dart';

class Instructions extends StatefulWidget {
  @override
  _InstructionsState createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> {
  void _handleSubmit() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            size: AppTheme.elementSize(
                screenHeight, 25, 25, 25, 25, 27, 33, 38, 45),
          ),
          onPressed: () {
            _handleSubmit();
          },
          color: AppTheme.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "A Quick Read",
                      style: TextStyle(
                          fontSize: AppTheme.elementSize(
                              screenHeight, 24, 26, 28, 30, 32, 40, 45, 50),
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkGrey),
                    ),
                    SizedBox(
                      height: AppTheme.elementSize(
                          screenHeight, 30, 30, 32, 32, 34, 43, 46, 50),
                    ),
                    Text(
                      "Thank you for signing up! We\'re super excited that you\'re here!",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: AppTheme.elementSize(
                              screenHeight, 14, 15, 16, 17, 18, 20, 24, 28),
                          color: AppTheme.darkGrey),
                    ),
                    SizedBox(
                      height: AppTheme.elementSize(
                          screenHeight, 16, 17, 18, 19, 20, 21, 23, 25),
                    ),
                    Text(
                      "A few things before we start...",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppTheme.elementSize(
                              screenHeight, 14, 15, 16, 17, 18, 20, 24, 28),
                          color: AppTheme.darkGrey),
                    ),
                    SizedBox(
                      height: AppTheme.elementSize(
                          screenHeight, 12, 13, 14, 15, 16, 17, 18, 20),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        UnorderedList([
                          "You can search for Mules (deliverers) around a place and match with them",
                          "Once matched, please chat with them to discuss your order specifics",
                          "When you receive your order, please remember to provide the PIN to the Mule to complete the delivery",
                          "We currently do not have payments integrated into the app and ask you to use cash, Venmo, ApplePay or GooglePay to pay the Mules. Please ensure that you are paying the correct amount by verifying the receipt",
                          "We are exploring different ways to incentivize users and Mules. The first model we are testing is a tip to the Mules. Please tip at least 15% of the order amount if under \$12 and at least 10% if over \$12. Please do not pay until after you receive the delivery",
                          "As a Mule, please ensure to provide accurate information about the delivery and send a picture of the receipt to the customer. Please ask the customer for their PIN to complete the delivery after you have received the payment",
                          "We ask everyone to ensure safety measures for themselves and their surroundings by wearing a mask and sanitizing frequently",
                          "We're bound to make mistakes and there might be things that you don't like a certain way! Your feedback and suggestions will be truly appreciated! Please reach out to us if you have any concerns or questions"
                        ])
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: AppTheme.elementSize(
                    screenHeight, 16, 17, 18, 19, 20, 21, 23, 25),
              ),
              button('Let\'s go!', _handleSubmit, screenHeight, context)
            ],
          ),
        ),
      ),
    );
  }
}
