import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/services/messages_service.dart';
import 'package:mule/models/data/user_data.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/widgets/stylized_button.dart';

abstract class MatchedPanel extends StatefulWidget {
  final OrderData order = GetIt.I.get<UserInfoStore>().activeOrder;
  final UserData other;
  final double opacity = 1.0;
  final SlidingUpWidgetController slidingUpWidgetController;
  final MapController mapController;
  final String headerString;

  MatchedPanel([
    this.slidingUpWidgetController,
    this.mapController,
    this.other,
    this.headerString,
  ]);

  @override
  _MatchedPanelState createState() => _MatchedPanelState();

  updateOrder(OrderData order) {
    mapController.updateDelivery(
      order.acceptedBy.location.toLatLng(),
      order.place.location.toLatLng(),
      order.destination.location.toLatLng(),
      .1,
    );
  }

  String getFormattedPhoneNumber(UserData data) {
    return data.phoneNumber.substring(0, 2) +
        " " +
        "(" +
        data.phoneNumber.substring(2, 5) +
        ") " +
        data.phoneNumber.substring(5, 8) +
        " - " +
        data.phoneNumber.substring(8, data.phoneNumber.length);
  }

  String getName(UserData data) {
    return data.name;
  }

  Image getImage(UserData data) {
    if (data.profilePicture != null) {
      return Image.network(data.profilePicture);
    }
    return Image.asset('assets/images/profile_picture_placeholder.png');
  }

  Future<bool> cancelRequest();
  Future<bool> completeRequest();
  void _initButtons();
}

class _MatchedPanelState extends State<MatchedPanel> {
  final MessagesService _service = GetIt.I.get<MessagesService>();

  @override
  void initState() {
    super.initState();
    widget._initButtons();
  }

  @override
  build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    widget.updateOrder(widget.order);

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
              widget.headerString,
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
                  child: widget.getImage(widget.other),
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
                      widget.getName(widget.other),
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
                          Icons.phone,
                          color: AppTheme.darkGrey,
                          size: AppTheme.elementSize(
                              screenHeight, 25, 25, 26, 26, 18, 20, 21, 22),
                        ),
                        Text(widget.getFormattedPhoneNumber(widget.other),
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
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: AppTheme.lightGrey.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.chat,
                      color: AppTheme.secondaryBlue,
                      size: AppTheme.elementSize(
                          screenHeight, 25, 25, 26, 26, 28, 36, 38, 40),
                    )),
                onTap: () => _service.sendSms(widget.other.phoneNumber),
              )
            ],
          ),
        )
      ],
    );
  }
}
