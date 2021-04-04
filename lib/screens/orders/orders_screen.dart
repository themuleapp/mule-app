import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/loading-animation.dart';
import 'package:mule/widgets/order_information_card.dart';
import 'package:mule/widgets/tab.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  Future<Map<Status, List<OrderData>>> myOrders = getOrders();
  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  ListView generateItemsList(Status orderStatus,
      Map<Status, List<OrderData>> orders, double screenHeight) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount:
          (orders.containsKey(orderStatus)) ? orders[orderStatus].length : 0,
      itemBuilder: (context, index) {
        return orderCard(orders[orderStatus][index], screenHeight);
      },
    );
  }

  InkWell orderCard(OrderData order, double screenHeight) {
    return InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 12, bottom: 8, left: 16, right: 16),
              child: Text(
                "${DateFormat('MMM dd - h:mm a').format(order.createdAt.toLocal()).toUpperCase()}",
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
                child: orderInformationCard(order.place.description,
                    order.destination.description, screenHeight)),
          ],
        ));
  }

  Widget requestTypeTabs(double screenHeight) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
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
          FutureBuilder(
            future: myOrders,
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
                      generateItemsList(
                          Status.ACCEPTED, snapshot.data, screenHeight),
                      generateItemsList(
                          Status.COMPLETED, snapshot.data, screenHeight),
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        physics:
            const PageScrollPhysics(parent: NeverScrollableScrollPhysics()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 30),
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
            requestTypeTabs(screenHeight),
          ],
        ),
      ),
    );
  }
}

Future<Map<Status, List<OrderData>>> getOrders() async {
  List<OrderData> orders = [];
  List<OrderData> history = await muleApiService.getUserHistory();
  OrderData ongoing = await muleApiService.getActiveRequest();

  if (history == null) {
    return {};
  }
  // Only show this one if I'm the user (creator) of it.
  if (ongoing != null && GetIt.I.get<UserInfoStore>().fullName != ongoing.acceptedBy.name) {
    orders.add(ongoing);
  }
  orders..addAll(history);
  return _sortOrders(orders);
}

Map<Status, List<OrderData>> _sortOrders(List<OrderData> orders) {
  Map<Status, List<OrderData>> sortedOrders = {};

  // Split orders by status
  Status.values.forEach((status) {
    sortedOrders.putIfAbsent(
        status, () => orders.where((order) => order.status == status).toList());
  });

  // Sort orders by time of creation
  sortedOrders.forEach((status, list) =>
      list.sort((a, b) => a.createdAt.compareTo(b.createdAt)));
  return sortedOrders;
}
