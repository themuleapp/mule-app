import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/res/requestedFromMeRes/requested_from_me_res.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/confirm_dialogue.dart';
import 'package:mule/widgets/tab.dart';

class RequestsScreen extends StatefulWidget {
  static final String ACCEPT = 'accept';
  static final String DECLINE = 'decline';

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen>
    with TickerProviderStateMixin {

  List<RequestedFromMeRes> requestedFromMe = [];
  TabController _tabController;

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    httpClient.getRequestedFromMeNotYetAccepted().then((res) => {
      setState(() {
        requestedFromMe.addAll(res);
      })
    });
  }

  ListView generateItemsList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: requestedFromMe.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(requestedFromMe[index].id),
          onDismissed: (direction) => _handleDismissed(direction, index),
          confirmDismiss: (direction) =>
              _confirmDismiss(context, direction, index),
          child: InkWell(
              onTap: () {
                print("${requestedFromMe[index].requestedItem} clicked");
              },
              child: ListTile(
                  title: Text('${requestedFromMe[index].requestedItem}')
              )
          ),
          background: slideRightBackground(),
          secondaryBackground: slideLeftBackground(),
        );
      },
    );
  }

  String _getActionDependingOnDirection(direction) {
    if (direction == DismissDirection.startToEnd) {
      return RequestsScreen.ACCEPT;
    } else {
      return RequestsScreen.DECLINE;
    }
  }

  Future<bool> _confirmDismiss(context, direction, index) async {
    String action = _getActionDependingOnDirection(direction);
    return await createConfirmDialogue(context, action) ?? false;
  }

  _handleDismissed(direction, index) async {
    String action = _getActionDependingOnDirection(direction);
    bool success;
    if (action == RequestsScreen.ACCEPT) {
      // Send api request
      // Remove from local list
      print(requestedFromMe[index].id);
      success =
          await httpClient.acceptRequestMadeToMe(requestedFromMe[index].id);
    } else {
      // Send api request
      // Remove from local list
      success =
          await httpClient.declineRequestMadeToMe(requestedFromMe[index].id);
    }
    if (!success) {
      createDialogWidget(context, 'There was a problem!',
          'We couldn\'t complete your request, please try again!');
    }
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.check,
              color: AppTheme.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Accept",
              style: TextStyle(
                color: AppTheme.white,
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.redAccent,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.close,
              color: AppTheme.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Dismiss",
              style: TextStyle(
                color: AppTheme.white,
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget requestTypeTabs(screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget> [
        TabBar(
          tabs: [
            tab('Available', screenHeight),
            tab('Dismissed', screenHeight),
            tab('Ongoing', screenHeight),
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
                  child: generateItemsList()
                ),
                Container(
                  child: Text("Dismissed"),
                ),
                Container(
                  child: Text("Ongoing"),
                )
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
              padding: EdgeInsets.only(
                  top: 20.0, left: 20, right: 20, bottom: 30),
              child: Text(
                "Requests",
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkGrey,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 24, 26, 28, 30, 32, 40, 45, 50),
                ),
              ),
            ),
            requestTypeTabs(screenHeight),
          ],
        ),
      ),
    );
  }
}
