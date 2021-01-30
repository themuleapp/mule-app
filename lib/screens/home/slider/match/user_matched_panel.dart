import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/config/messages_service.dart';
import 'package:mule/models/data/user_data.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/clip_height.dart';
import 'package:mule/widgets/stylized_button.dart';

class UserMatchedPanel extends StatefulWidget {
  final SlidingUpWidgetController slidingUpWidgetController;
  final MapController mapController;
  final double loadingBarHeight;
  final double opacity = 1.0;
  final StylizedButton buttonBridge;

  UserMatchedPanel({
    this.slidingUpWidgetController,
    this.mapController,
    this.loadingBarHeight = 5.0,
    this.buttonBridge,
  });

  @override
  _UserMatchedPanelState createState() => _UserMatchedPanelState();
}

class _UserMatchedPanelState extends State<UserMatchedPanel> {
  Future<OrderData> order = httpClient.getActiveRequest();

  final MessagesService _service = GetIt.I.get<MessagesService>();

  @override
  void initState() {
    super.initState();
    widget.buttonBridge?.callback = cancelRequest;
  }

  updateOrder(OrderData order) async {
    widget.mapController.updateDelivery(
      order.acceptedBy.location.toLatLng(),
      order.place.location.toLatLng(),
      order.destination.location.toLatLng(),
      .1,
    );
  }

  String muleName(OrderData order) {
    return order.acceptedBy.name;
  }

  cancelRequest() async {
    OrderData order = await this.order;
    if (await httpClient.deleteActiveRequest(order)) {
      widget.slidingUpWidgetController.panelIndex =
          PanelIndex.DestinationAndSearch;
    } else {
      createDialogWidget(context, "Something went wrong...",
          "Something went wrong when cancelling your request, please try again later.");
    }
  }

  @override
  build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final double loadingBar = widget.slidingUpWidgetController.radius * 2;
    return FutureBuilder(
        future: order,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Container(
                height: loadingBar,
                child: ClipRect(
                  clipper: ClipHeightQuarter(height: widget.loadingBarHeight),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.all(Radius.circular(loadingBar / 2)),
                    child: LinearProgressIndicator(
                      minHeight: widget.loadingBarHeight,
                      backgroundColor: AppTheme.secondaryBlue,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.lightBlue),
                    ),
                  ),
                ),
              ),
            );
          } else {
            updateOrder(snapshot.data);
            MuleData mule = snapshot.data.acceptedBy;
            Image muleImg;
            if (mule.profilePicture != null) {
              muleImg = Image.network(mule.profilePicture);
            } else {
              muleImg =
                  Image.asset('assets/images/profile_picture_placeholder.png');
            }

            String formattedPhoneNumber = mule.phoneNumber.substring(0, 2) +
                " " +
                "(" +
                mule.phoneNumber.substring(2, 5) +
                ") " +
                mule.phoneNumber.substring(5, 8) +
                " - " +
                mule.phoneNumber.substring(8, mule.phoneNumber.length);
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: widget.opacity,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: AppTheme.elementSize(
                              screenHeight, 20, 22, 24, 26, 0, 0, 0, 0),
                          left: 16,
                          right: 16),
                      child: Text(
                        'En Route',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: AppTheme.elementSize(
                              screenHeight, 18, 19, 19, 20, 22, 26, 30, 36),
                          color: AppTheme.darkerText,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                            //color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: muleImg,
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
                                  fontSize: AppTheme.elementSize(screenHeight,
                                      16, 16, 17, 17, 18, 24, 26, 28),
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.phone,
                                    color: AppTheme.darkGrey,
                                    size: AppTheme.elementSize(screenHeight, 25,
                                        25, 26, 26, 18, 20, 21, 22),
                                  ),
                                  Text(formattedPhoneNumber,
                                      style: TextStyle(
                                        color: AppTheme.lightGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: AppTheme.elementSize(
                                          screenHeight,
                                          14,
                                          14,
                                          15,
                                          15,
                                          16,
                                          18,
                                          21,
                                          24,
                                        ),
                                      )),
                                ],
                              )
                            ],
                          ),
                        )),
                        GestureDetector(
                          child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                color: AppTheme.lightGrey.withOpacity(0.1),
                              ),
                              child: Icon(
                                Icons.chat,
                                color: AppTheme.secondaryBlue,
                                size: AppTheme.elementSize(screenHeight, 25, 25,
                                    26, 26, 28, 36, 38, 40),
                              )),
                          onTap: () => _service.sendSms(mule.phoneNumber),
                        ),
                      ],
                    ),
                  )
                ]);
          }
        });
  }
}
