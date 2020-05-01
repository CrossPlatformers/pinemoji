// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromMap(json.decode(str));

String userToJson(User data) => json.encode(data.toMap());

class User {
    final String id;
    final String name;
    final String surname;
    final ExtraInfo extraInfo;
    final String model;
    final String brand;
    final String os;
    final String phoneNumber;

    User({
        @required this.id,
        @required this.name,
        @required this.surname,
        @required this.extraInfo,
        @required this.model,
        @required this.brand,
        @required this.os,
        @required this.phoneNumber,
    });

    User copyWith({
        String id,
        String name,
        String surname,
        ExtraInfo extraInfo,
        String model,
        String brand,
        String os,
        String phoneNumber,
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
        );

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        surname: json["surname"] == null ? null : json["surname"],
        extraInfo: json["extraInfo"] == null ? null : ExtraInfo.fromMap(json["extraInfo"]),
        model: json["model"] == null ? null : json["model"],
        brand: json["brand"] == null ? null : json["brand"],
        os: json["os"] == null ? null : json["os"],
        phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    );

    Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "surname": surname == null ? null : surname,
        "extraInfo": extraInfo == null ? null : extraInfo.toMap(),
        "model": model == null ? null : model,
        "brand": brand == null ? null : brand,
        "os": os == null ? null : os,
        "phoneNumber": phoneNumber == null ? null : phoneNumber,
    };
}

class ExtraInfo {
    ExtraInfo();

    ExtraInfo copyWith({
    }) => 
        ExtraInfo(
        );

    factory ExtraInfo.fromMap(Map<String, dynamic> json) => ExtraInfo(
    );

    Map<String, dynamic> toMap() => {
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
