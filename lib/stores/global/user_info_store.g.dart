// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserInfoStore on _UserInfoStore, Store {
  Computed<String> _$fullNameComputed;

  @override
  String get fullName =>
      (_$fullNameComputed ??= Computed<String>(() => super.fullName,
              name: '_UserInfoStore.fullName'))
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

  final _$_UserInfoStoreActionController =
      ActionController(name: '_UserInfoStore');

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
  String toString() {
    return '''
fullName: ${fullName}
    ''';
  }
}
