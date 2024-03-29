import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/home/slider/match/waiting_to_match_panel.dart';
import 'package:mule/screens/home/slider/panel.dart';
import 'package:mule/screens/home/slider/search/search_panel.dart';
import 'package:mule/services/messages_service.dart';
import 'package:mule/models/data/user_data.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/stores/location/location_store.dart';
import 'package:mule/widgets/confirm_action_dialogue.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class MatchedPanel extends Panel {
  final OrderData order = GetIt.I.get<UserInfoStore>().activeOrder;
  final String headerString;
  final UserData match;

  MatchedPanel({
    SlidingUpWidgetController slidingUpWidgetController,
    MapController mapController,
    PanelController controller,
    double screenHeight,
    this.headerString,
    this.match,
  }) : super(
          slidingUpWidgetController: slidingUpWidgetController,
          mapController: mapController,
          controller: controller,
          screenHeight: screenHeight,
        );

  @override
  _MatchedPanelState createState() => _MatchedPanelState();

  void mapStateCallback() {
    mapController
      ..updateDelivery(
        order.acceptedBy.location.toLatLng(),
        order.place.location.toLatLng(),
        order.destination.location.toLatLng(),
        order.createdBy.name == GetIt.I.get<UserInfoStore>().fullName,
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

  void cancelRequest(BuildContext context) async {
    bool success = createConfirmActionDialogue(context);
    if (success == null) {
      return;
    }
    if (success) {
      slidingUpWidgetController.panel = SearchPanel.from(this);
    } else {
      createDialogWidget(
        context,
        "Oops... Something went wrong",
        "Something went wrong while trying to confirm your delivery. Please try again later.",
      );
    }
  }

  @override
  double get minHeight {
    return screenHeight / 5;
  }

  @override
  double get maxHeight {
    return minHeight;
  }
}

class _MatchedPanelState extends State<MatchedPanel> {
  final MessagesService _service = GetIt.I.get<MessagesService>();

  @override
  void initState() {
    super.initState();
    widget.init(this);

    GetIt.I.get<UserInfoStore>().activeOrder.addListener(_orderListener);
  }

  void _orderListener() {
    OrderData newOrder = GetIt.I.get<UserInfoStore>().activeOrder;

    if (newOrder == null || newOrder.status == Status.COMPLETED) {
      widget.slidingUpWidgetController.panel = SearchPanel.from(widget);
      dispose();
    }
    if (newOrder.status == Status.OPEN) {
      widget.slidingUpWidgetController.panel = WaitingToMatchPanel.from(widget);
    }
  }

  void _launchMaps() async {
    String origin =
        "${GetIt.I.get<LocationStore>().currentLocation.lat},${GetIt.I.get<LocationStore>().currentLocation.lng}";
    String source =
        "${GetIt.I.get<LocationStore>().place.location.lat},${GetIt.I.get<LocationStore>().place.location.lng}";
    String destination =
        "${GetIt.I.get<LocationStore>().destination.location.lat},${GetIt.I.get<LocationStore>().destination.location.lng}";

    String url = "https://www.google.com/maps/dir/?api=1&origin=" +
        origin +
        "&destination=" +
        destination +
        "&waypoints=" +
        source +
        "&travelmode=walking&dir_action=navigate";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: 1.0,
          child: Padding(
            padding: EdgeInsets.only(
                top: AppTheme.elementSize(
                    widget.screenHeight, 20, 22, 24, 26, 26, 28, 32, 34),
                left: 16,
                right: 16),
            child: Text(
              widget.headerString,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: AppTheme.elementSize(
                    widget.screenHeight, 18, 19, 19, 20, 22, 26, 30, 36),
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
                height: AppTheme.elementSize(
                    widget.screenHeight, 52, 54, 56, 58, 60, 60, 60, 60),
                width: AppTheme.elementSize(
                    widget.screenHeight, 52, 54, 56, 58, 60, 60, 60, 60),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  //color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: widget.getImage(widget.match),
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
                      widget.getName(widget.match),
                      style: TextStyle(
                        color: AppTheme.darkerText,
                        fontWeight: FontWeight.w700,
                        fontSize: AppTheme.elementSize(widget.screenHeight, 16,
                            16, 17, 17, 18, 24, 26, 28),
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
                          size: AppTheme.elementSize(widget.screenHeight, 16,
                              16, 17, 17, 18, 20, 21, 22),
                        ),
                        Text(widget.getFormattedPhoneNumber(widget.match),
                            style: TextStyle(
                              color: AppTheme.lightGrey,
                              fontWeight: FontWeight.w500,
                              fontSize: AppTheme.elementSize(
                                widget.screenHeight,
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
                    height: AppTheme.elementSize(
                        widget.screenHeight, 42, 44, 46, 48, 50, 50, 50, 50),
                    width: AppTheme.elementSize(
                        widget.screenHeight, 42, 44, 46, 48, 50, 50, 50, 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: AppTheme.lightGrey.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.chat,
                      color: AppTheme.secondaryBlue,
                      size: AppTheme.elementSize(
                          widget.screenHeight, 25, 25, 26, 26, 28, 36, 38, 40),
                    )),
                onTap: () => _service.sendSms(widget.match.phoneNumber),
              ),
              Visibility(
                visible:
                    GetIt.I.get<UserInfoStore>().activeOrder.createdBy.name !=
                        GetIt.I.get<UserInfoStore>().fullName,
                child: SizedBox(
                  width: AppTheme.elementSize(
                      widget.screenHeight, 8, 8, 8, 9, 12, 14, 16, 18),
                ),
              ),
              Visibility(
                visible:
                    GetIt.I.get<UserInfoStore>().activeOrder.createdBy.name !=
                        GetIt.I.get<UserInfoStore>().fullName,
                child: GestureDetector(
                  child: Container(
                      height: AppTheme.elementSize(
                          widget.screenHeight, 42, 44, 46, 48, 50, 50, 50, 50),
                      width: AppTheme.elementSize(
                          widget.screenHeight, 42, 44, 46, 48, 50, 50, 50, 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: AppTheme.lightGrey.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.directions,
                        color: AppTheme.secondaryBlue,
                        size: AppTheme.elementSize(widget.screenHeight, 25, 25,
                            26, 26, 28, 36, 38, 40),
                      )),
                  onTap: () => _launchMaps(),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
