// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromMap(json.decode(str));

String userToJson(User data) => json.encode(data.toMap());

class User {
  String id;
  String name;
  String surname;
  Map extraInfo;
  String model;
  String brand;
  String os;
  String phoneNumber;
  LatLng location;

  User({
    this.id,
    @required this.name,
    @required this.surname,
    @required this.extraInfo,
    @required this.model,
    @required this.brand,
    @required this.os,
    @required this.phoneNumber,
    @required this.location,
  });

  User copyWith({
    String id,
    String name,
    String surname,
    Map extraInfo,
    String model,
    String brand,
    String os,
    String phoneNumber,
    LatLng location,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        extraInfo: extraInfo ?? this.extraInfo,
        model: model ?? this.model,
        brand: brand ?? this.brand,
        os: os ?? this.os,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        location: location ?? this.location,
      );

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        surname: json["surname"] == null ? null : json["surname"],
        extraInfo:
            json["extraInfo"] == null ? null : Map.from(json["extraInfo"]),
        model: json["model"] == null ? null : json["model"],
        brand: json["brand"] == null ? null : json["brand"],
        os: json["os"] == null ? null : json["os"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        location: json["location"] == null ? null : json["location"],
      );

  factory User.fromSnapshot(DocumentSnapshot snapshot) => User(
        id: snapshot.data["id"] == null ? null : snapshot.data["id"],
        name: snapshot.data["name"] == null ? null : snapshot.data["name"],
        surname:
            snapshot.data["surname"] == null ? null : snapshot.data["surname"],
        extraInfo: snapshot.data["extraInfo"] == null
            ? null
            : Map.from(snapshot.data["extraInfo"]),
        model: snapshot.data["model"] == null ? null : snapshot.data["model"],
        brand: snapshot.data["brand"] == null ? null : snapshot.data["brand"],
        os: snapshot.data["os"] == null ? null : snapshot.data["os"],
        phoneNumber: snapshot.data["phoneNumber"] == null
            ? null
            : snapshot.data["phoneNumber"],
        location: snapshot.data["location"] != null ? LatLng((snapshot.data["location"] as GeoPoint).latitude,(snapshot.data["location"] as GeoPoint).longitude) : null,
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "surname": surname == null ? null : surname,
        "extraInfo": extraInfo == null ? null : extraInfo,
        "model": model == null ? null : model,
        "brand": brand == null ? null : brand,
        "os": os == null ? null : os,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
        "location": location == null ? null : GeoPoint(location.latitude, location.longitude),
      };
}

//{
//"id": "id",
//"name":"",
//"surname":"",
//"extraInfo":{},
//"model": "hex",
//"brand":"",
//"os":"",
//"phoneNumber":""
//}
