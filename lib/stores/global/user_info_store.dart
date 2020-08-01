import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobx/mobx.dart';
import 'package:mule/config/config.dart';
import 'package:mule/models/res/profileRes/profile_res.dart';
import 'package:flutter/material.dart';

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
  void updateEverythingFromrRes(ProfileRes res) {
    this._firstName = res.firstName;
    this._lastName = res.lastName;
    this._email = res.email;
    this._phoneNumber = res.phoneNumber;
  }

  // TODO finish
  @action
  Future<void> updateProfilePicture() async {
    final String token = await Config.getToken();

    this._profilePicture = CachedNetworkImageProvider(
      "${Config.BASE_URL}profile/profile-image",
      scale: 1.0,
      headers: {'Authorization': token},
    );
    // var oldImg = this._profilePicture;
    // this._profilePicture = NetworkImage(
    //     '${Config.BASE_URL}profile/profile-image',
    //     headers: {'Authorization': token});

    // print('They equal? ${oldImg == this._profilePicture}');
  }

  @computed
  String get fullName => '$_firstName $_lastName';
  String get email => this._email;
  String get phoneNumber => this._phoneNumber;
  String get firstName => this._firstName;
  ImageProvider get profilePicture => this._profilePicture;
}
