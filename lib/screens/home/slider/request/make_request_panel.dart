import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/data/location_data.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/models/data/suggestion.dart';
import 'package:mule/models/req/placeRequest/place_request_data.dart';
import 'package:mule/models/res/mulesAroundRes/mules_around_res.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/stores/location/location_store.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/order_information_card.dart';
import 'package:mule/widgets/stylized_button.dart';

class MakeRequestPanel extends StatefulWidget {
  final SlidingUpWidgetController slidingUpWidgetController;
  final MapController mapController;
  final double opacity = 1.0;
  final StylizedButton buttonBridge;

  MakeRequestPanel({
    this.slidingUpWidgetController,
    this.mapController,
    this.buttonBridge,
  });
  _MakeRequestPanelState createState() => _MakeRequestPanelState();
}

class _MakeRequestPanelState extends State<MakeRequestPanel> {
  Future<int> getNumMulesAround() async {
    LocationData locationToCheckMulesAround =
        GetIt.I.get<LocationStore>().place.location;
    MulesAroundRes mulesAroundRes =
        await httpClient.getMulesAroundMeLocation(locationToCheckMulesAround);
    return mulesAroundRes.numMules;
  }

  onReturnToSearch() {
    widget.slidingUpWidgetController.panelIndex =
        PanelIndex.DestinationAndSearch;
    widget.mapController.unfocusRoute();
  }

  @override
  void initState() {
    super.initState();
    widget.buttonBridge?.callback = onReturnToSearch;
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
        Padding(
          padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom:
                  AppTheme.elementSize(screenHeight, 2, 3, 4, 6, 8, 10, 12, 14),
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
                      future: getNumMulesAround(),
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
                AppTheme.elementSize(screenHeight, 0, 0, 0, 2, 8, 10, 10, 10)),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: widget.opacity,
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
                  screenHeight, 36, 38, 42, 46, 48, 48, 48, 48),
              color: AppTheme.secondaryBlue,
              borderRadius: AppTheme.elementSize(
                  screenHeight, 8, 10, 12, 14, 16, 16, 16, 16),
              animate: true,
              type: ProgressButtonType.Raised,
              onPressed: () async {
                int score = await Future.delayed(
                    const Duration(milliseconds: 2500), () => 42);
                // After [onPressed], it will trigger animation running backwards, from end to beginning
                LocationData currentLocation =
                    GetIt.I.get<LocationStore>().currentLocation;
                PlacesSuggestion place = GetIt.I.get<LocationStore>().place;
                DestinationSuggestion destination =
                    GetIt.I.get<LocationStore>().destination;

                PlaceRequestData placeRequestData = PlaceRequestData(
                  LocationDesciption(place.location, place.description),
                  LocationDesciption(
                      destination.location, destination.description),
                );
                bool success = await httpClient.placeRequest(placeRequestData);
                if (!success) {
                  createDialogWidget(
                    context,
                    'There was a problem',
                    'Please try again later!',
                  );
                }
                return () async {
                  // Optional returns is returning a VoidCallback that will be called
                  // after the animation is stopped at the beginning.
                  // A best practice would be to do time-consuming task in [onPressed],
                  // and do page navigation in the returned VoidCallback.
                  // So that user won't missed out the reverse animation.
                  if (success) {
                    widget.slidingUpWidgetController.panelIndex =
                        PanelIndex.WaitingToMatch;
                  }
                };
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
