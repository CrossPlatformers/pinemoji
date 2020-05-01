// To parse this JSON data, do
//
//     final answer = answerFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Answer answerFromJson(String str) => Answer.fromMap(json.decode(str));

String answerToJson(Answer data) => json.encode(data.toMap());

class Answer {
    final String answerText;
    final String ownerId;
    final String location;

    Answer({
        @required this.answerText,
        @required this.ownerId,
        @required this.location,
    });

    Answer copyWith({
        String answerText,
        String ownerId,
        String location,
    }) => 
        Answer(
            answerText: answerText ?? this.answerText,
            ownerId: ownerId ?? this.ownerId,
            location: location ?? this.location,
        );

    factory Answer.fromMap(Map<String, dynamic> json) => Answer(
        answerText: json["answerText"] == null ? null : json["answerText"],
        ownerId: json["ownerId"] == null ? null : json["ownerId"],
        location: json["location"] == null ? null : json["location"],
    );

    Map<String, dynamic> toMap() => {
        "answerText": answerText == null ? null : answerText,
        "ownerId": ownerId == null ? null : ownerId,
        "location": location == null ? null : location,
    };
}


// {"answerText":"xtexs","ownerId":"ownerId","location":"location"}
