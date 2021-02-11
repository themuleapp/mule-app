import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/match/matched_panel.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/widgets/stylized_button.dart';

class UserMatchedPanel extends MatchedPanel {
  final double opacity = 1.0;
  final StylizedButton buttonBridge;

  UserMatchedPanel({
    this.buttonBridge,
    SlidingUpWidgetController slidingUpWidgetController,
    MapController mapController,
  }) : super(
          slidingUpWidgetController,
          mapController,
          GetIt.I.get<UserInfoStore>().activeOrder.acceptedBy,
          "You are en route",
        );

  @override
  Future<bool> cancelRequest() async {
    return await muleApiService.userDeleteActiveRequest(order);
  }

  @override
  Future<bool> completeRequest() async {
    print("Completed request");
  }

  void _initButtons() {
    buttonBridge.callback = cancelRequest;
  }
}
