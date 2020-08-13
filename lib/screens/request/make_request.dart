import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';

class MakeRequestScreen extends StatefulWidget {
  @override
  _MakeRequestScreenState createState() => _MakeRequestScreenState();
}

class _MakeRequestScreenState extends State<MakeRequestScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  double opacity = 0.0;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
  }

  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: AppTheme.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Positioned(
              top: (MediaQuery.of(context).size.height / 1.6),
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.lightGrey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: screenHeight / 4,
                        maxHeight: screenHeight - 120
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: opacity,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 18, right: 16),
                            child: Text(
                              'Confirm Details',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: AppTheme.darkerText,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 8, top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.people,
                                      color: AppTheme.secondaryBlue,
                                      size: 24,
                                    ),
                                    Text(
                                      ' 12 ',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 21,
                                        color: AppTheme.lightGrey,
                                      ),
                                    ),
                                    Text(
                                      'Mules around',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 21,
                                        color: AppTheme.lightGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.lightGrey
                                          .withOpacity(0.1),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                                top: 15),
                                            hintText: "From here - address",
                                            prefixIcon: IconButton(
                                              splashColor: AppTheme.lightBlue,
                                              icon: Icon(
                                                Icons.my_location,
                                                color: AppTheme.secondaryBlue,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox (
                                        height: 10
                                      ),
                                      Container(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(
                                                top: 15),
                                            hintText: "To here - address",
                                            prefixIcon: IconButton(
                                              splashColor: AppTheme.lightBlue,
                                              icon: Icon(
                                                Icons.place,
                                                color: AppTheme.secondaryBlue,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                )
                              )
                            ),
                          ),
                        ),
                        SizedBox (
                            height: 10
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: opacity,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, bottom: 8, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0),
                                        ),
                                        border: Border.all(
                                            color: AppTheme.lightGrey
                                                .withOpacity(0.2)),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: AppTheme.lightGrey
                                            .withOpacity(0.5),
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                    child: GestureDetector(
                                      child: Container(
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: AppTheme.secondaryBlue,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(16.0),
                                          ),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: AppTheme
                                                    .secondaryBlue
                                                    .withOpacity(0.5),
                                                offset: const Offset(1.1, 1.1),
                                                blurRadius: 10.0),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Request',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              letterSpacing: 0.0,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {},
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.height / 1.2) - 220,
              right: 35,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: CurvedAnimation(
                    parent: animationController, curve: Curves.fastOutSlowIn),
                child: Card(
                  color: AppTheme.secondaryBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  elevation: 10.0,
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: AppTheme.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}