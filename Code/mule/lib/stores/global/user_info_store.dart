import 'package:mobx/mobx.dart';

part 'user_info_store.g.dart';

class UserInfoStore = _UserInfoStore with _$UserInfoStore;

abstract class _UserInfoStore with Store {
  @observable
  String _firstName;

  @observable
  String _lastName;

  @computed
  String get fullName => '$_firstName $_lastName';

  @action
  void updateFirstAndLastNames(String firstName, String lastName) {
    this._firstName = firstName;
    this._lastName = lastName;
  }
}
