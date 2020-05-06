// To parse this JSON data, do
//
//     final Hospital = HospitalFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

Hospital hospitaFromJson(String str) => Hospital.fromMap(json.decode(str));

String hospitalToJson(Hospital data) => json.encode(data.toMap());

class Hospital {
  String id;
  String name;
  String mapName;
  String address;
  String phoneNumber;
  LatLng location;

  Hospital({
    this.id,
    @required this.name,
    @required this.mapName,
    @required this.address,
    @required this.phoneNumber,
    @required this.location,
  });

  Hospital copyWith({
    String id,
    String name,
    String mapName,
    String address,
    String phoneNumber,
    LatLng location,
  }) =>
      Hospital(
        id: id ?? this.id,
        name: name ?? this.name,
        mapName: mapName ?? this.mapName,
        address: address ?? this.address,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        location: location ?? this.location,
      );

  factory Hospital.fromMap(Map<String, dynamic> json) => Hospital(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        mapName: json["mapName"] == null ? null : json["mapName"],
        address: json["address"] == null ? null : json["address"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
        location: json["location"] == null ? null : json["location"],
      );

  factory Hospital.fromSnapshot(DocumentSnapshot snapshot) => Hospital(
        id: snapshot.data["id"] == null ? null : snapshot.data["id"],
        name: snapshot.data["name"] == null ? null : snapshot.data["name"],
        mapName: snapshot.data["mapName"] == null ? null : snapshot.data["mapName"],
        address:
            snapshot.data["address"] == null ? null : snapshot.data["address"],
        phoneNumber: snapshot.data["phoneNumber"] == null
            ? null
            : snapshot.data["phoneNumber"],
        location: snapshot.data["location"] != null ? LatLng((snapshot.data["location"] as GeoPoint).latitude,(snapshot.data["location"] as GeoPoint).longitude) : null,
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "mapName": mapName == null ? null : mapName,
        "address": address == null ? null : address,
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
