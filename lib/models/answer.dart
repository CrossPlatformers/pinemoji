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

  Answer({
    @required this.answerText,
    @required this.ownerId,
  });

  Answer copyWith({
    String answerText,
    String ownerId,
  }) =>
      Answer(
        answerText: answerText ?? this.answerText,
        ownerId: ownerId ?? this.ownerId,
      );

  factory Answer.fromMap(Map<String, dynamic> json) => Answer(
    answerText: json["answerText"] == null ? null : json["answerText"],
    ownerId: json["ownerId"] == null ? null : json["ownerId"],
  );

  Map<String, dynamic> toMap() => {
    "answerText": answerText == null ? null : answerText,
    "ownerId": ownerId == null ? null : ownerId,
  };
}
