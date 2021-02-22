import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  void initState() {
    super.initState();
  }

    _launchURL() async {
    const url = 'https://www.themuleapp.com/support';
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: true,
        enableJavaScript: true,
        enableDomStorage: true,
        forceSafariVC: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SingleChildScrollView(
        child: Container(
          child: SafeArea(
            child: Container(
              color: AppTheme.white,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 20,
                          left: 16,
                          right: 16),
                      child: Image.asset(
                        'assets/images/help.png',
                        height: screenHeight * 0.48,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 25),
                      child: Text(
                        'Facing a problem or have a suggestion?',
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
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Container(
                          width: AppTheme.elementSize(screenHeight, 120, 130,
                              140, 150, 160, 180, 200, 220),
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
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                _launchURL();
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    'Get help',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: AppTheme.elementSize(
                                          screenHeight,
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
      ),
    );
  }
}
