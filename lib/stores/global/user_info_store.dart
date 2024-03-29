import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:mule/models/data/order_data.dart';
import 'package:mule/models/data/suggestion.dart';
import 'package:mule/models/res/profileRes/profile_res.dart';
import 'package:flutter/material.dart';
import 'package:mule/services/mule_api_service.dart';
import 'package:mule/stores/location/location_store.dart';

part 'user_info_store.g.dart';

class UserInfoStore = _UserInfoStore with _$UserInfoStore;

abstract class _UserInfoStore with Store {
  static final String _defaultImagePath =
      'assets/images/profile_picture_placeholder.png';

  @observable
  String _firstName = '';

  @observable
  String _lastName = '';

  @observable
  String _email = '';

  @observable
  String _phoneNumber = '';

  @observable
  ImageProvider _profilePicture = AssetImage(_defaultImagePath);

  @observable
  bool _isMule = true;

  @observable
  OrderData _activeOrder = null;

  @action
  void updateEmail(String email) {
    this._email = email;
  }

  @action
  void updatePhoneNumber(String phoneNumber) {
    this._phoneNumber = phoneNumber;
  }

  @action
  void updateFirstAndLastNames(String firstName, String lastName) {
    this._firstName = firstName;
    this._lastName = lastName;
  }

  @action
  void updateIsMule(bool isMule) {
    this._isMule = isMule;
  }

  @action
  void updateEverythingFromrRes(ProfileRes res) {
    this._firstName = res.firstName;
    this._lastName = res.lastName;
    this._email = res.email;
    this._phoneNumber = res.phoneNumber;
    this._isMule = res.isMule;
  }

  @action
  Future<void> updateProfilePicture() async {
    ImageProvider imageProvider = await muleApiService.getProfilePicture();

    if (imageProvider != null) this._profilePicture = imageProvider;
  }

  @action
  Future<OrderData> updateActiveOrder() async {
    OrderData newOrder = await muleApiService.getActiveRequest();
    OrderData oldOrder = _activeOrder;

    if (_activeOrder == null || newOrder == null) {
      _activeOrder = newOrder;
    }
    if (oldOrder != null) {
      oldOrder.update(newOrder);
    }

    if (_activeOrder != null) {
      GetIt.I.get<LocationStore>().updateDestination(
            DestinationSuggestion.fromLocationDescription(
                _activeOrder.destination),
          );
      GetIt.I.get<LocationStore>().updatePlace(
            PlacesSuggestion.fromLocationDescription(_activeOrder.place),
          );
    }
    return _activeOrder;
  }

  @action
  Future<bool> deleteActiveOrder() async {
    bool success = false;

    if (_activeOrder == null) {
      return success;
    }
    if (_activeOrder.acceptedBy != null &&
        _activeOrder.acceptedBy.name == fullName) {
      success = await muleApiService.muleDeleteActiveRequest(_activeOrder);
    } else {
      success = await muleApiService.userDeleteActiveRequest(_activeOrder);
    }
    if (success) {
      updateActiveOrder();
      GetIt.I.get<LocationStore>().updateDestination(null);
      GetIt.I.get<LocationStore>().updatePlace(null);
    }
    return success;
  }

  @computed
  String get fullName => '$_firstName $_lastName';
  @computed
  String get email => this._email;
  @computed
  String get phoneNumber => this._phoneNumber;
  @computed
  String get firstName => this._firstName;
  @computed
  bool get isMule => this._isMule;
  @computed
  OrderData get activeOrder => this._activeOrder;

  ImageProvider get profilePicture => this._profilePicture;
}
