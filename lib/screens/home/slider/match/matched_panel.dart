import 'package:flutter/material.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/data/mule_data.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';

class MatchedPanel extends StatefulWidget {
  final SlidingUpWidgetController slidingUpWidgetController;
  final MapController mapController;
  final double opacity = 1.0;

  MatchedPanel({this.slidingUpWidgetController, this.mapController});

  @override
  _MatchedPanelState createState() => _MatchedPanelState();
}

class _MatchedPanelState extends State<MatchedPanel> {
  Order order;
  MuleData mule;

  @override
  void initState() {
    updateOrder();
    super.initState();
  }

  updateOrder() async {
    setState(() async {
      order = await httpClient.activeRequest();
      if (order.status == Status.ACCEPTED) {
        mule = order.mule;
        widget.mapController.updateDelivery(
          order.mule.location.toLatLng(),
          order.place.toLatLng(),
          order.destination.toLatLng(),
          .1,
        );
      }
    });
  }

  @override
  build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: widget.opacity,
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
            child: Text(
              'En Route',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: AppTheme.darkerText,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  //color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                      'assets/images/profile_picture_placeholder.png'),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        (mule != null) ? mule.name : "LOADING",
                        style: TextStyle(
                          color: AppTheme.darkerText,
                          fontWeight: FontWeight.w700,
                          fontSize: AppTheme.elementSize(
                              screenHeight, 16, 16, 17, 17, 18, 24, 26, 28),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: AppTheme.goldenYellow,
                            size: AppTheme.elementSize(
                                screenHeight, 25, 25, 26, 26, 18, 20, 21, 22),
                          ),
                          Text('4.7 stars', //replace with rating
                              style: TextStyle(
                                color: AppTheme.lightGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: AppTheme.elementSize(screenHeight, 14,
                                    14, 15, 15, 16, 18, 21, 24),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: AppTheme.lightGrey.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.chat,
                      color: AppTheme.secondaryBlue,
                      size: AppTheme.elementSize(
                          screenHeight, 25, 25, 26, 26, 28, 36, 38, 40),
                    )),
                onTap: () {},
              ),
              SizedBox(width: 15),
              GestureDetector(
                child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: AppTheme.lightGrey.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.report_problem,
                      color: AppTheme.secondaryBlue,
                      size: AppTheme.elementSize(
                          screenHeight, 25, 25, 26, 26, 28, 36, 38, 40),
                    )),
                onTap: () {},
              )
            ],
          ),
        )
      ],
    );
  }
}
