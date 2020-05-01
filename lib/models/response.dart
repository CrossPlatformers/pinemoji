// To parse this JSON data, do
//
//     final response = responseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Response responseFromJson(String str) => Response.fromMap(json.decode(str));

String responseToJson(Response data) => json.encode(data.toMap());

class Response {
  final String date;
  final String image;
  final String text;
  final String state;

  Response({
    @required this.date,
    @required this.image,
    @required this.text,
    @required this.state,
  });

  Response copyWith({
    String date,
    String image,
    String text,
    String state,
  }) =>
      Response(
        date: date ?? this.date,
        image: image ?? this.image,
        text: text ?? this.text,
        state: state ?? this.state,
      );

  factory Response.fromMap(Map<String, dynamic> json) => Response(
    date: json["date"] == null ? null : json["date"],
    image: json["image"] == null ? null : json["image"],
    text: json["text"] == null ? null : json["text"],
    state: json["state"] == null ? null : json["state"],
  );

  Map<String, dynamic> toMap() => {
    "date": date == null ? null : date,
    "image": image == null ? null : image,
    "text": text == null ? null : text,
    "state": state == null ? null : state,
  };
}
