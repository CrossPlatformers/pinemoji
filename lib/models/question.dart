// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Question questionFromJson(String str) => Question.fromMap(json.decode(str));

String questionToJson(Question data) => json.encode(data.toMap());

class Question {
  final String description;
  final String type;
  final String answerList;

  Question({
    @required this.description,
    @required this.type,
    @required this.answerList,
  });

  Question copyWith({
    String description,
    String type,
    String answerList,
  }) =>
      Question(
        description: description ?? this.description,
        type: type ?? this.type,
        answerList: answerList ?? this.answerList,
      );

  factory Question.fromMap(Map<String, dynamic> json) => Question(
    description: json["description"] == null ? null : json["description"],
    type: json["type"] == null ? null : json["type"],
    answerList: json["answerList"] == null ? null : json["answerList"],
  );

  Map<String, dynamic> toMap() => {
    "description": description == null ? null : description,
    "type": type == null ? null : type,
    "answerList": answerList == null ? null : answerList,
  };
}

//{
//"description": "id",
//"type": "hex",
//"answerList":""
//}
