import 'package:flutter/material.dart';
import 'package:mule/models/data/location_data.dart';

class MulesAroundRes {
  int numMules;
  List<LocationData> mules;

  MulesAroundRes({
    @required this.numMules,
    @required this.mules,
  });

  MulesAroundRes.fromJson(Map<String, dynamic> jsonData)
      : this.numMules = jsonData['numMules'],
        this.mules = new List<LocationData>.from(
                jsonData['locations'].map((el) => LocationData.fromJson(el)))
            .toList();
}
