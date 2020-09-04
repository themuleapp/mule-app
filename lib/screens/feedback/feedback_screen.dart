import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';

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
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SingleChildScrollView(
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
                    child: Image.asset(
                      'assets/images/feedback.png',
                      height: MediaQuery.of(context).size.height * 0.45,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 25),
                    child: Text(
                      'Any thoughts or suggestions?',
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
                  _buildComposer(screenHeight),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: Container(
                        width: AppTheme.elementSize(screenHeight, 120, 130, 140,
                            150, 160, 180, 200, 220),
                        height: AppTheme.elementSize(
                            screenHeight, 40, 40, 45, 45, 45, 50, 50, 50),
                        decoration: BoxDecoration(
                          color: AppTheme.lightBlue,
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
                                    fontSize: AppTheme.elementSize(screenHeight,
                                        14, 15, 15, 17, 19, 21, 22, 24),
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
              ),
            ),
          ),
        ),
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
                textCapitalization: TextCapitalization.sentences,
                enableSuggestions: true,
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
