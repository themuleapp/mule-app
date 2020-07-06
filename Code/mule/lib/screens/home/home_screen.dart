import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mule/screens/home/sliding_up_widget.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/screens/login/email_verification_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<bool> checkEmailValidation() async {
    final res = await httpClient.handleCheckEmailVerification();
    if (res.statusCode == 200) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => EmailVerification()));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    checkEmailValidation();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: SlidingUpWidget(),
        ),
      ),
    );
  }
}
