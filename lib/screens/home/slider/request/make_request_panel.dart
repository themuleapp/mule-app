import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/screens/home/slider/match/waiting_to_match_panel.dart';
import 'package:mule/screens/home/slider/panel.dart';
import 'package:mule/screens/home/slider/search/search_panel.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/models/data/location_data.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/models/data/suggestion.dart';
import 'package:mule/models/req/placeRequest/place_request_data.dart';
import 'package:mule/models/res/mulesAroundRes/mules_around_res.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/stores/location/location_store.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/order_information_card.dart';
import 'package:mule/widgets/stylized_button.dart';

class MakeRequestPanel extends Panel {
  MakeRequestPanel({
    PanelController controller,
    SlidingUpWidgetController slidingUpWidgetController,
    MapController mapController,
    double screenHeight,
  }) : super(
          mapController: mapController,
          controller: controller,
          slidingUpWidgetController: slidingUpWidgetController,
          screenHeight: screenHeight,
        );

  MakeRequestPanel.from(Panel panel)
      : super(
          mapController: panel.mapController,
          controller: panel.controller,
          slidingUpWidgetController: panel.slidingUpWidgetController,
          screenHeight: panel.screenHeight,
        );

  _MakeRequestPanelState createState() => _MakeRequestPanelState();

  Future<bool> placeRequest() async {
    PlacesSuggestion place = GetIt.I.get<LocationStore>().place;
    DestinationSuggestion destination =
        GetIt.I.get<LocationStore>().destination;

    PlaceRequestData placeRequestData = PlaceRequestData(
      LocationDesciption(place.location, place.description),
      LocationDesciption(destination.location, destination.description),
    );
    bool success = await muleApiService.placeRequest(placeRequestData);

    if (success) {
      await GetIt.I.get<UserInfoStore>().updateActiveOrder();
    }
    return success;
  }

  Future<int> getNumMulesAround() async {
    LocationData locationToCheckMulesAround =
        GetIt.I.get<LocationStore>().place.location;
    MulesAroundRes mulesAroundRes = await muleApiService
        .getMulesAroundMeLocation(locationToCheckMulesAround);
    return mulesAroundRes.numMules;
  }

  @override
  void mapStateCallback() {
    mapController..focusOnRoute();
  }

  void onReturnToSearch() {
    slidingUpWidgetController.panel = SearchPanel.from(this);
  }

  List<StylizedButton> get buttons {
    StylizedButton cancel = CancelButton(
      size: buttonSize,
      callback: onReturnToSearch,
      margin: EdgeInsets.only(bottom: buttonSpacing),
    );
    return [cancel];
  }

  @override
  double get maxHeight {
    return screenHeight / 3;
  }

  @override
  double get minHeight {
    return maxHeight;
  }
}

class _MakeRequestPanelState extends State<MakeRequestPanel> {
  @override
  void initState() {
    super.initState();
    widget.init(this);
  }

  @override
  build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: 1.0,
            child: Padding(
              padding: EdgeInsets.only(
                  top: AppTheme.elementSize(
                      screenHeight, 20, 22, 24, 26, 32, 34, 36, 38),
                  left: 16,
                  right: 16),
              child: Text(
                'Confirm Details',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 18, 19, 20, 21, 22, 26, 30, 36),
                  color: AppTheme.darkerText,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom:
                  AppTheme.elementSize(screenHeight, 2, 3, 4, 5, 6, 7, 10, 12),
              top: AppTheme.elementSize(
                  screenHeight, 6, 7, 10, 12, 16, 18, 20, 22)),
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
                      size: AppTheme.elementSize(
                          screenHeight, 18, 19, 20, 21, 22, 24, 28, 32),
                    ),
                    FutureBuilder(
                      future: widget.getNumMulesAround(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: CircularProgressIndicator(),
                            height: 20.0,
                            width: 20.0,
                          );
                        }
                        return Text(
                          ' ${snapshot.data} ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: AppTheme.elementSize(
                                screenHeight, 17, 18, 19, 20, 21, 24, 28, 34),
                            color: AppTheme.lightGrey,
                          ),
                        );
                      },
                    ),
                    Text(
                      'Mules around',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: AppTheme.elementSize(
                            screenHeight, 17, 18, 19, 20, 21, 24, 28, 34),
                        color: AppTheme.lightGrey,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        orderInformationCard(GetIt.I.get<LocationStore>().place.description,
            GetIt.I.get<LocationStore>().destination.description, screenHeight),
        SizedBox(
            height:
                AppTheme.elementSize(screenHeight, 0, 0, 0, 2, 5, 7, 10, 10)),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: 1.0,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
            child: ProgressButton(
              defaultWidget: Text(
                'Request',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: AppTheme.elementSize(
                      screenHeight, 14, 15, 16, 17, 18, 18, 18, 18),
                  letterSpacing: 0.0,
                  color: AppTheme.white,
                ),
              ),
              progressWidget: CircularProgressIndicator(
                  backgroundColor: AppTheme.white,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.secondaryBlue)),
              width: MediaQuery.of(context).size.width,
              height: AppTheme.elementSize(
                  screenHeight, 36, 38, 42, 48, 48, 48, 48, 48),
              color: AppTheme.secondaryBlue,
              borderRadius: AppTheme.elementSize(
                  screenHeight, 8, 10, 12, 16, 16, 16, 16, 16),
              animate: true,
              type: ProgressButtonType.Raised,
              onPressed: () async {
                if (await widget.placeRequest()) {
                  widget.slidingUpWidgetController.panel =
                      WaitingToMatchPanel.from(widget);
                } else {
                  createDialogWidget(
                    context,
                    'There was a problem',
                    'Please try again later!',
                  );
                }
              },
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom,
        )
      ],
    );
  }
}
