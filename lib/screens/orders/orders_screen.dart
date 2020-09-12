import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/widgets/tab.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {

  TabController _tabController;

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Widget requestTypeTabs(screenHeight) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget> [
          TabBar(
            tabs: [
              tab('Upcoming', screenHeight),
              tab('Past', screenHeight),
            ],
            unselectedLabelColor: AppTheme.lightestGrey,
            indicatorColor: AppTheme.secondaryBlue,
            labelColor: AppTheme.black,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 4.0,
            isScrollable: false,
            controller: _tabController,
          ),
          Container(
            padding: EdgeInsets.only(top: 16, right: 16, left: 16),
            height: 100,
            child: TabBarView(
              controller: _tabController,
                children: <Widget>[
                  Container(
                    child: Text("Upcoming")
                  ),
                  Container(
                    child: Text("Past"),
                  ),
                ]
            ),
          )
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: Text(
                "Orders",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkGrey,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 24, 26, 28, 30, 32, 40, 45, 50),
                ),
              ),
            ),
            SizedBox(
              height: AppTheme.elementSize(
                  screenHeight, 10, 10, 12, 12, 14, 20, 20, 22),
            ),
            requestTypeTabs(screenHeight),
          ],
        ),
      ),
    );
  }
}
