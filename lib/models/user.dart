// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromMap(json.decode(str));

String userToJson(User data) => json.encode(data.toMap());

class User {
  final String id;
  final String model;
  final String brand;
  final String os;
  final String phoneNumber;

  User({
    @required this.id,
    @required this.model,
    @required this.brand,
    @required this.os,
    @required this.phoneNumber,
  });

  User copyWith({
    String id,
    String model,
    String brand,
    String os,
    String phoneNumber,
  }) =>
      User(
        id: id ?? this.id,
        model: model ?? this.model,
        brand: brand ?? this.brand,
        os: os ?? this.os,
        phoneNumber: phoneNumber ?? this.phoneNumber,
      );

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    model: json["model"] == null ? null : json["model"],
    brand: json["brand"] == null ? null : json["brand"],
    os: json["os"] == null ? null : json["os"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "model": model == null ? null : model,
    "brand": brand == null ? null : brand,
    "os": os == null ? null : os,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
  };
}

//
//{
//"id": "id",
//"model": "hex",
//"brand":"",
//"os":"",
//"phoneNumber":""
//}
