// To parse this JSON data, do
//
//     final request = requestFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:pinemoji/models/response.dart';

Request requestFromJson(String str) => Request.fromMap(json.decode(str));

String requestToJson(Request data) => json.encode(data.toMap());

class Request {
  String id;
  String ownerId;
  LatLng location;
  String locationName;
  String companyId;
  String emoji;
  String image;
  String state;
  List<Response> responseList;
  String option;
  DateTime date;

  Request({
    this.id,
    @required this.ownerId,
    @required this.location,
    @required this.locationName,
    @required this.companyId,
    @required this.emoji,
    @required this.image,
    @required this.state,
    @required this.responseList,
    @required this.option,
    @required this.date,
  });

  Request copyWith({
    String id,
    String ownerId,
    LatLng location,
    String locationName,
    String companyId,
    String emoji,
    String image,
    String state,
    List<Response> responseList,
    String option,
    DateTime date,
  }) =>
      Request(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        location: location ?? this.location,
        locationName: locationName ?? this.locationName,
        companyId: companyId ?? this.companyId,
        emoji: emoji ?? this.emoji,
        image: image ?? this.image,
        state: state ?? this.state,
        responseList: responseList ?? this.responseList,
        option: option ?? this.option,
        date: date ?? this.date,
      );

  factory Request.fromMap(Map<String, dynamic> json) => Request(
    id: json["id"] == null ? null : json["id"],
    ownerId: json["ownerId"] == null ? null : json["ownerId"],
    location: json["location"] == null ? null : json["location"],
    locationName: json["locationName"] == null ? null : json["locationName"],
    companyId: json["companyId"] == null ? null : json["companyId"],
    emoji: json["emoji"] == null ? null : json["emoji"],
    image: json["image"] == null ? null : json["image"],
    state: json["state"] == null ? null : json["state"],
    responseList: json["responseList"] == null ? null : List<Response>.from(json["responseList"].map((x) => Response.fromMap(x))),
    option: json["option"] == null ? null : json["option"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  factory Request.fromSnapshot(DocumentSnapshot snapshot) =>
      Request(
        id: snapshot.data["id"] ?? snapshot.documentID,
        ownerId: snapshot.data["ownerId"],
        location: LatLng((snapshot.data["location"] as GeoPoint).latitude,(snapshot.data["location"] as GeoPoint).longitude),
        locationName: snapshot.data["locationName"],
        companyId: snapshot.data["companyId"],
        emoji: snapshot.data["emoji"],
        image: snapshot.data["image"],
        state: snapshot.data["image"],
        date: snapshot.data["date"] != null
            ? (snapshot.data["date"] as Timestamp).toDate()
            : null,
        option: snapshot.data["option"],
        responseList: snapshot.data["response"] == null
            ? []
            : List<Response>.from(
                snapshot.data["response"].map((x) => responseFromJson(x))),
      );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "ownerId": ownerId == null ? null : ownerId,
    "location": location == null ? null : GeoPoint(location.latitude, location.longitude),
    "locationName": locationName == null ? null : locationName,
    "companyId": companyId == null ? null : companyId,
    "emoji": emoji == null ? null : emoji,
    "image": image == null ? null : image,
    "state": state == null ? null : state,
    "responseList": responseList == null ? null : List<dynamic>.from(responseList.map((x) => x.toMap())),
    "option": option == null ? null : option,
    "date": date == null ? null : date,
  };
}



//{
//"id": "id",
//"ownerId":"",
//"location":"",
//"companyId":"",
//"emoji": "",
//"image":"",
//"state":"",
//"responseList": [{"date":"date","image":"","text":"text","state":"state"}],
//"option":"",
//"time":""
//}
