import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:mule/config/app_theme.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/models/req/deleteAccount/delete_account_req.dart';
import 'package:mule/screens/welcome_screen.dart';
import 'package:mule/widgets/alert_widget.dart';

class DeleteAccount extends StatefulWidget {
  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  String reason = "No feedback";

  @override
  void initState() {
    super.initState();
  }

  _handleSubmit() async {
    DeleteAccountReq deleteAccountReq = DeleteAccountReq(
      reason: this.reason,
    );
    final Response res =
        await muleApiService.handleDeleteAccount(deleteAccountReq);
    if (res.statusCode == 200) {
      // TODO show a little reminder that it successded
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      // TODO Response data field seems to be of the incorrect type
      createDialogWidget(context, 'Failed!', 'Please try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: AppTheme.elementSize(
                screenHeight, 25, 28, 30, 33, 25, 26, 27, 29),
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          color: AppTheme.black,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SafeArea(
              child: Container(
                color: AppTheme.white,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 20,
                            left: 16,
                            right: 16),
                        // TODO Image not decompressable error
                        // child: Image.asset('assets/images/Delete.png'),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 25),
                        child: Text(
                          "We're sorry to see you go!",
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
                          "We would love to hear why you're leaving",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppTheme.elementSize(
                                screenHeight, 14, 15, 16, 18, 19, 20, 22, 24),
                          ),
                        ),
                      ),
                      _buildComposer(screenHeight),
                      Container(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          "Are you sure you want to leave?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppTheme.elementSize(
                                screenHeight, 17, 18, 20, 21, 22, 25, 27, 28),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                          child: Container(
                            width: AppTheme.elementSize(screenHeight, 120, 130,
                                140, 150, 160, 180, 200, 220),
                            height: AppTheme.elementSize(
                                screenHeight, 40, 40, 45, 45, 45, 50, 50, 50),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
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
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _handleSubmit();
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: AppTheme.elementSize(
                                              screenHeight,
                                              14,
                                              15,
                                              15,
                                              17,
                                              19,
                                              21,
                                              22,
                                              24),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            "CANCEL",
                            style: TextStyle(
                                fontSize: AppTheme.elementSize(screenHeight, 17,
                                    15, 16, 17, 18, 20, 22, 25),
                                fontWeight: FontWeight.bold,
                                color: AppTheme.lightText),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildComposer(double screenHeight) {
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
                maxLines: null,
                onChanged: (String reason) {
                  this.reason = reason;
                },
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 16,
                  color: AppTheme.darkGrey,
                ),
                cursorColor: AppTheme.lightBlue,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'How can we improve...',
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
