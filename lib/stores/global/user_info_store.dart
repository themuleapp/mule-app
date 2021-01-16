import 'package:mobx/mobx.dart';
import 'package:mule/models/res/profileRes/profile_res.dart';
import 'package:flutter/material.dart';
import 'package:mule/config/http_client.dart';

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

  // TODO add updateIsMule and add to updateEverythingFromRes
  @observable
  bool _isMule = true;

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
  }

  @action
  Future<void> updateProfilePicture() async {
    ImageProvider imageProvider = await httpClient.getProfilePicture();

    if (imageProvider != null) this._profilePicture = imageProvider;
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
  ImageProvider get profilePicture => this._profilePicture;
}
