class UserData {
  final String name;
  final String phoneNumber;

  UserData({this.name, this.phoneNumber});

  UserData.fromJson(Map<String, dynamic> jsonData)
      : this.name = jsonData['name'],
        this.phoneNumber = jsonData['phoneNumber'];
}
