import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/config/app_theme.dart';
import 'package:mule/config/http_client.dart';
import 'package:mule/models/data/location_data.dart';
import 'package:mule/models/data/suggestion.dart';
import 'package:mule/models/req/placeRequest/place_request_data.dart';
import 'package:mule/models/res/mulesAroundRes/mules_around_res.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/stores/location/location_store.dart';
import 'package:mule/widgets/alert_widget.dart';
import 'package:mule/widgets/order_information_card.dart';

class MakeRequestPanel extends StatelessWidget {
  final SlidingUpWidgetController slidingUpWidgetController;
  final MapController mapController;
  final double opacity = 1.0;

  MakeRequestPanel({
    this.slidingUpWidgetController,
    this.mapController,
  });

  Future<int> getNumMulesAround() async {
    LocationData locationToCheckMulesAround =
        GetIt.I.get<LocationStore>().place.location;
    MulesAroundRes mulesAroundRes =
        await httpClient.getMulesAroundMeLocation(locationToCheckMulesAround);
    return mulesAroundRes.numMules;
  }

  _onReturnToSearch() {
    slidingUpWidgetController.panelIndex = PanelIndex.DestinationAndSearch;
    mapController.unfocusRoute();
  }

  @override
  build(BuildContext context) {
    // Only animate after everything is done building
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        slidingUpWidgetController.panelController.animatePanelToSnapPoint(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: opacity,
          child: Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 16, right: 16),
            child: Text(
              'Confirm Details',
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
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
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
                      size: 24,
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
                            fontSize: 21,
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
                        fontSize: 21,
                        color: AppTheme.lightGrey,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        orderInformationCard(
            GetIt.I.get<LocationStore>().place.description,
            GetIt.I.get<LocationStore>().destination.description),
        SizedBox(height: 10),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: opacity,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 48,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                        border: Border.all(
                            color: AppTheme.lightGrey.withOpacity(0.2)),
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppTheme.lightGrey.withOpacity(0.5),
                        size: 28,
                      ),
                    ),
                  ),
                  onTap: () => _onReturnToSearch(),
                ),
                const SizedBox(
                  width: 16,
                ),
                ProgressButton(
                  defaultWidget: Text(
                    'Request',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 0.0,
                      color: AppTheme.white,
                    ),
                  ),
                  progressWidget: CircularProgressIndicator(
                      backgroundColor: AppTheme.white,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.secondaryBlue)),
                  width: MediaQuery.of(context).size.width - 100,
                  height: 48,
                  color: AppTheme.secondaryBlue,
                  borderRadius: 16,
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
                      currentLocation.lat,
                      currentLocation.lng,
                      place.description,
                      destination.description,
                      'Coffee',
                    );
                    bool success =
                        await httpClient.placeRequest(placeRequestData);
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
                        slidingUpWidgetController.panelIndex =
                            PanelIndex.WaitingToMatch;
                      }
                    };
                  },
                ),
              ],
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
