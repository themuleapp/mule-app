import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/confirm_dialogue.dart';
import 'package:mule/widgets/loading-animation.dart';
import 'package:mule/widgets/order_information_card.dart';
import 'package:mule/widgets/tab.dart';

class RequestsScreen extends StatefulWidget {
  static final String ACCEPT = 'accept';
  static final String DECLINE = 'decline';

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  Future<Map<Status, List<OrderData>>> requestedFromMe = getOrders();

  @override
  initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  _updateOrders() {
    setState(() {
      requestedFromMe = getOrders();
    });
  }

  ListView generateItemsList(Status orderStatus,
      Map<Status, List<OrderData>> orders, bool dismissable) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount:
          (orders.containsKey(orderStatus)) ? orders[orderStatus].length : 0,
      itemBuilder: (context, index) {
        return dismissable
            ? dismissableCard(orders[orderStatus][index])
            : orderCard(orders[orderStatus][index]);
      },
    );
  }

  Dismissible dismissableCard(OrderData order) {
    return Dismissible(
      key: Key(order.id),
      onDismissed: (direction) => _handleDismissed(direction, order.id),
      confirmDismiss: (direction) =>
          _confirmDismiss(context, direction, order.id),
      child: orderCard(order),
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
    );
  }

  InkWell orderCard(OrderData order) {
    return InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 12, bottom: 8, left: 16, right: 16),
              child: Text(
                "${DateFormat('MMM dd - H:m a').format(order.createdAt.toLocal()).toUpperCase()}",
                style: TextStyle(
                  color: AppTheme.darkGrey,
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: orderInformationCard(
                    order.place.description, order.destination.description)),
          ],
        ));
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

  _handleDismissed(DismissDirection direction, String requestId) async {
    String action = _getActionDependingOnDirection(direction);
    bool success;
    if (action == RequestsScreen.ACCEPT) {
      // Send api request
      // Remove from local list
      success = await httpClient.acceptRequest(requestId);
    } else {
      // Send api request
      // Remove from local list
      success = await httpClient.dismissRequest(requestId);
    }
    if (!success) {
      createDialogWidget(context, 'There was a problem!',
          'We couldn\'t complete your request, please try again!');
    } else {
      _updateOrders();
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

  Widget requestTypeTabs(double screenHeight) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
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
          FutureBuilder(
            future: requestedFromMe,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  createDialogWidget(
                    context,
                    "Oops, something went wrong...",
                    "Please try again later!",
                  );
                  return Text("The data could not be loaded...",
                      style: TextStyle(color: AppTheme.lightGrey));
                  // DO SOMETHING
                }
                return Container(
                  height: screenHeight,
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      generateItemsList(Status.OPEN, snapshot.data, true),
                      generateItemsList(Status.DISMISSED, snapshot.data, false),
                      generateItemsList(Status.ACCEPTED, snapshot.data, false),
                    ],
                  ),
                );
              } else {
                return Container(
                  height: 200,
                  child: SpinKitDoubleBounce(
                    color: AppTheme.lightBlue,
                  ),
                );
              }
            },
          ),
        ]);
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
            padding:
                EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 30),
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
      )),
    );
  }
}

Future<Map<Status, List<OrderData>>> getOrders() async {
  List<OrderData> orders = [];
  List<OrderData> openOrders = await httpClient.getOpenRequests();
  List<OrderData> history = await httpClient.getMuleHistory();
  OrderData accepted = await httpClient.getActiveRequest();

  if (openOrders == null || history == null) {
    return {};
  }
  orders
    ..addAll(openOrders)
    ..addAll(history)
    ..add(accepted);
  return _sortOrders(orders);
}

Map<Status, List<OrderData>> _sortOrders(List<OrderData> orders) {
  Map<Status, List<OrderData>> sortedOrders = {};

  Status.values.forEach((status) {
    sortedOrders.putIfAbsent(
        status, () => orders.where((order) => order.status == status).toList());
  });
  return sortedOrders;
}
