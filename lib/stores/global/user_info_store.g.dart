// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserInfoStore on _UserInfoStore, Store {
  Computed<String> _$fullNameComputed;

  @override
  String get fullName =>
      (_$fullNameComputed ??= Computed<String>(() => super.fullName,
              name: '_UserInfoStore.fullName'))
          .value;
  Computed<String> _$emailComputed;

  @override
  String get email => (_$emailComputed ??=
          Computed<String>(() => super.email, name: '_UserInfoStore.email'))
      .value;
  Computed<String> _$phoneNumberComputed;

  @override
  String get phoneNumber =>
      (_$phoneNumberComputed ??= Computed<String>(() => super.phoneNumber,
              name: '_UserInfoStore.phoneNumber'))
          .value;
  Computed<String> _$firstNameComputed;

  @override
  String get firstName =>
      (_$firstNameComputed ??= Computed<String>(() => super.firstName,
              name: '_UserInfoStore.firstName'))
          .value;

  final _$_firstNameAtom = Atom(name: '_UserInfoStore._firstName');

  @override
  String get _firstName {
    _$_firstNameAtom.reportRead();
    return super._firstName;
  }

  @override
  set _firstName(String value) {
    _$_firstNameAtom.reportWrite(value, super._firstName, () {
      super._firstName = value;
    });
  }

  final _$_lastNameAtom = Atom(name: '_UserInfoStore._lastName');

  @override
  String get _lastName {
    _$_lastNameAtom.reportRead();
    return super._lastName;
  }

  @override
  set _lastName(String value) {
    _$_lastNameAtom.reportWrite(value, super._lastName, () {
      super._lastName = value;
    });
  }

  final _$_emailAtom = Atom(name: '_UserInfoStore._email');

  @override
  String get _email {
    _$_emailAtom.reportRead();
    return super._email;
  }

  @override
  set _email(String value) {
    _$_emailAtom.reportWrite(value, super._email, () {
      super._email = value;
    });
  }

  final _$_phoneNumberAtom = Atom(name: '_UserInfoStore._phoneNumber');

  @override
  String get _phoneNumber {
    _$_phoneNumberAtom.reportRead();
    return super._phoneNumber;
  }

  @override
  set _phoneNumber(String value) {
    _$_phoneNumberAtom.reportWrite(value, super._phoneNumber, () {
      super._phoneNumber = value;
    });
  }

  final _$_UserInfoStoreActionController =
      ActionController(name: '_UserInfoStore');

  @override
  void updateEmail(String email) {
    final _$actionInfo = _$_UserInfoStoreActionController.startAction(
        name: '_UserInfoStore.updateEmail');
    try {
      return super.updateEmail(email);
    } finally {
      _$_UserInfoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updatePhoneNumber(String phoneNumber) {
    final _$actionInfo = _$_UserInfoStoreActionController.startAction(
        name: '_UserInfoStore.updatePhoneNumber');
    try {
      return super.updatePhoneNumber(phoneNumber);
    } finally {
      _$_UserInfoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateFirstAndLastNames(String firstName, String lastName) {
    final _$actionInfo = _$_UserInfoStoreActionController.startAction(
        name: '_UserInfoStore.updateFirstAndLastNames');
    try {
      return super.updateFirstAndLastNames(firstName, lastName);
    } finally {
      _$_UserInfoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateEverythingFromrRes(ProfileRes res) {
    final _$actionInfo = _$_UserInfoStoreActionController.startAction(
        name: '_UserInfoStore.updateEverythingFromrRes');
    try {
      return super.updateEverythingFromrRes(res);
    } finally {
      _$_UserInfoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fullName: ${fullName},
email: ${email},
phoneNumber: ${phoneNumber},
firstName: ${firstName}
    ''';
  }
}
