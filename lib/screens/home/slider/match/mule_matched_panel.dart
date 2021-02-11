import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mule/screens/home/map/map_widget.dart';
import 'package:mule/screens/home/slider/sliding_up_widget.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/stores/global/user_info_store.dart';
import 'package:mule/widgets/stylized_button.dart';

import 'matched_panel.dart';

class MuleMatchedPanel extends MatchedPanel {
  final StylizedButton buttonBridge;
  final StylizedButton buttonBridge2;

  MuleMatchedPanel({
    this.buttonBridge,
    this.buttonBridge2,
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
    return await muleApiService.muleDeleteActiveRequest(order);
  }

  @override
  Future<bool> completeRequest() async {
    print("Completed request");
  }

  @override
  void _initButtons() {
    buttonBridge?.callback = cancelRequest;
    buttonBridge2?.callback = completeRequest;
  }
}
