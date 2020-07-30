import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/config.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/screens/welcome_screen.dart';
import 'package:mule/screens/legal/legal.dart';
import 'package:mule/screens/profile/profile.dart';
import 'package:mule/stores/global/user_info_store.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;

  @override
  void initState() {
    setdDrawerListArray();
    super.initState();
  }

  _handleSignOut() async {
    await httpClient.handleSignOut();
    await Config.deleteToken();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  void setdDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Places,
        labelName: 'Places',
        icon: Icon(Icons.map),
      ),
      DrawerList(
        index: DrawerIndex.Orders,
        labelName: 'Orders',
        icon: Icon(Icons.shopping_basket),
      ),
      DrawerList(
        index: DrawerIndex.Chat,
        labelName: 'Chat',
        icon: Icon(Icons.chat),
      ),
      DrawerList(
        index: DrawerIndex.Settings,
        labelName: 'Settings',
        icon: Icon(Icons.settings),
      ),
      DrawerList(
        index: DrawerIndex.Feedback,
        labelName: 'Feedback',
        icon: Icon(Icons.feedback),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: 'Report',
        icon: Icon(Icons.report_problem),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white.withOpacity(0.5),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: AppTheme.elementSize(
                      screenHeight, 5, 10, 20, 40, 45, 50, 60, 70)),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      AnimatedBuilder(
                        animation: widget.iconAnimationController,
                        builder: (BuildContext context, Widget child) {
                          return ScaleTransition(
                            scale: AlwaysStoppedAnimation<double>(1.0 -
                                (widget.iconAnimationController.value) * 0.2),
                            child: RotationTransition(
                              turns: AlwaysStoppedAnimation<double>(
                                  Tween<double>(begin: 0.0, end: 24.0)
                                          .animate(CurvedAnimation(
                                              parent: widget
                                                  .iconAnimationController,
                                              curve: Curves.fastOutSlowIn))
                                          .value /
                                      360),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: AppTheme.elementSize(screenHeight, 4,
                                        4.5, 4.5, 5, 5, 6, 7, 8),
                                    top: AppTheme.elementSize(screenHeight, 1,
                                        1.5, 1.5, 2, 2, 3, 3.5, 4)),
                                child: Container(
                                  height: AppTheme.elementSize(screenHeight,
                                      100, 115, 125, 130, 135, 170, 185, 200),
                                  width: AppTheme.elementSize(screenHeight, 100,
                                      115, 125, 130, 135, 170, 185, 200),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: AppTheme.darkGrey
                                              .withOpacity(0.6),
                                          offset: const Offset(2.0, 4.0),
                                          blurRadius: 8),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    child: ClipOval(
                                      child: GetIt.I
                                          .get<UserInfoStore>()
                                          .profilePicture,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => Profile()));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Observer(
                          builder: (_) => GestureDetector(
                            child: Text(
                              GetIt.I.get<UserInfoStore>().fullName,
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.darkGrey,
                                fontSize: AppTheme.elementSize(screenHeight, 19,
                                    21, 22, 24, 25, 28, 30, 32),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Profile()));
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Be a Mule",
                              style: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkGrey,
                                fontSize: AppTheme.elementSize(screenHeight, 15,
                                    16, 18, 19, 20, 22, 24, 26),
                              ),
                            ),
                            Container(
                              height: AppTheme.elementSize(
                                  screenHeight, 25, 25, 25, 25, 25, 30, 30, 35),
                              child: Switch(
                                value: true,
                                activeColor: AppTheme.lightBlue,
                                onChanged: (bool state) {},
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height:
                  AppTheme.elementSize(screenHeight, 0, 0, 0, 1, 3, 6, 8, 10),
            ),
            Divider(
              height: 1,
              color: AppTheme.darkGrey.withOpacity(0.6),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(0.0),
                itemCount: drawerList.length,
                itemBuilder: (BuildContext context, int index) {
                  return inkwell(drawerList[index], screenHeight);
                },
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 10.0, left: 15, right: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      "Legal",
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightGrey,
                        fontSize: AppTheme.elementSize(
                            screenHeight, 14, 15, 15, 16, 17, 19, 21, 23),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Legal()));
                    },
                  ),
                  Text(
                    "v1.0.0",
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightGrey,
                      fontSize: AppTheme.elementSize(
                          screenHeight, 14, 15, 15, 16, 17, 19, 21, 23),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: AppTheme.darkGrey.withOpacity(0.6),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: AppTheme.elementSize(
                          screenHeight, 16, 16, 17, 17, 18, 20, 22, 24),
                      color: AppTheme.darkText,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  trailing: Icon(
                    Icons.power_settings_new,
                    color: Colors.red,
                    size: AppTheme.elementSize(
                        screenHeight, 24, 25, 25, 26, 27, 29, 31, 35),
                  ),
                  onTap: this._handleSignOut,
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget inkwell(DrawerList listData, double screenHeight) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: AppTheme.elementSize(
                        screenHeight, 30, 35, 40, 40, 45, 50, 55, 60),
//                     decoration: BoxDecoration(
//                       color: widget.screenIndex == listData.index
//                           ? AppTheme.lightBlue
//                           : Colors.transparent,
//                       borderRadius: new BorderRadius.only(
//                         topLeft: Radius.circular(0),
//                         topRight: Radius.circular(16),
//                         bottomLeft: Radius.circular(0),
//                         bottomRight: Radius.circular(16),
//                       ),
//                     ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? AppTheme.black
                                  : AppTheme.black),
                        )
                      : Icon(
                          listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? AppTheme.black
                              : AppTheme.black,
                          size: AppTheme.elementSize(
                              screenHeight, 24, 25, 25, 26, 27, 29, 31, 35),
                        ),
                  const Padding(
                    padding: EdgeInsets.all(6),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: AppTheme.elementSize(
                          screenHeight, 16, 16, 17, 17, 18, 20, 22, 24),
                      color: widget.screenIndex == listData.index
                          ? AppTheme.black
                          : AppTheme.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: AppTheme.elementSize(
                                  screenHeight, 5, 5, 5, 6, 7, 8, 8, 8),
                              bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: AppTheme.elementSize(
                                screenHeight, 38, 40, 41, 46, 46, 51, 56, 61),
                            decoration: BoxDecoration(
                              color: AppTheme.lightBlue.withOpacity(0.5),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  Places,
  Orders,
  Chat,
  Settings,
  Help,
  Feedback,
  Testing,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
