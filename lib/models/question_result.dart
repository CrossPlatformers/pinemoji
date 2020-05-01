// To parse this JSON data, do
//
//     final questionResult = questionResultFromJson(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:pinemoji/models/answer.dart';

QuestionResult questionResultFromJson(String str) =>
    QuestionResult.fromMap(json.decode(str));

String questionResultToJson(QuestionResult data) => json.encode(data.toMap());

class QuestionResult {
  final String questionText;
  final List<Answer> answerList;

  QuestionResult({
    @required this.questionText,
    @required this.answerList,
  });

  QuestionResult copyWith({
    String questionText,
    List<Answer> answerList,
  }) =>
      QuestionResult(
        questionText: questionText ?? this.questionText,
        answerList: answerList ?? this.answerList,
      );

  factory QuestionResult.fromMap(Map<String, dynamic> json) => QuestionResult(
        questionText:
            json["questionText"] == null ? null : json["questionText"],
        answerList: json["answerList"] == null
            ? null
            : List<Answer>.from(
                json["answerList"].map((x) => Answer.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "questionText": questionText == null ? null : questionText,
        "answerList": answerList == null
            ? null
            : List<dynamic>.from(answerList.map((x) => x.toMap())),
      };
}

//{"questionText":"","answerList":[{"answerText":"xtexs","ownerId":"ownerId"}]}
