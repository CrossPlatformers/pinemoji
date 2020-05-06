// To parse this JSON data, do
//
//     final question = questionFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'answer.dart';

Question questionFromJson(String str) => Question.fromMap(json.decode(str));

String questionToJson(Question data) => json.encode(data.toMap());

class Question {
  String id;
  final String description;
  final String type;
  final List<Answer> answerList;

  Question({
    this.id,
    @required this.description,
    @required this.type,
    @required this.answerList,
  });

  Question copyWith({
    String id,
    String description,
    String type,
    List<String> answerList,
  }) =>
      Question(
        id: id ?? this.id,
        description: description ?? this.description,
        type: type ?? this.type,
        answerList: answerList ?? this.answerList,
      );

  factory Question.fromMap(Map<String, dynamic> json) => Question(
    id: json["id"] == null ? null : json["id"],
    description: json["description"] == null ? null : json["description"],
    type: json["type"] == null ? null : json["type"],
    answerList: json["answerList"] == null ? null : List<Answer>.from(json["answerList"].map((x) => Answer.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "description": description == null ? null : description,
    "type": type == null ? null : type,
    "answerList": answerList == null ? null : List<dynamic>.from(answerList.map((x) => x.toMap())),
  };
}

//{
//"description": "id",
//"type": "hex",
//"answerList":""
//}
