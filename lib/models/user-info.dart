import 'package:pinemoji/models/user.dart';

class UserInfo {
  String id;
  String name;
  String surname;
  String phoneNumber;

  init(User user) {
    this.id = user.id;
    this.name = user.name;
    this.surname = user.surname;
    this.phoneNumber = user.phoneNumber;
  }
}
