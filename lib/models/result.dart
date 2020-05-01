// To parse this JSON data, do
//
//     final result = resultFromJson(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:pinemoji/models/question_result.dart';

Result resultFromJson(String str) => Result.fromMap(json.decode(str));

String resultToJson(Result data) => json.encode(data.toMap());

class Result {
  final String surveyId;
  final List<QuestionResult> questionResultList;

  Result({
    @required this.surveyId,
    @required this.questionResultList,
  });

  Result copyWith({
    String surveyId,
    List<QuestionResult> questionResultList,
  }) =>
      Result(
        surveyId: surveyId ?? this.surveyId,
        questionResultList: questionResultList ?? this.questionResultList,
      );

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        surveyId: json["surveyId"] == null ? null : json["surveyId"],
        questionResultList: json["questionResultList"] == null
            ? null
            : List<QuestionResult>.from(json["questionResultList"]
                .map((x) => QuestionResult.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "surveyId": surveyId == null ? null : surveyId,
        "questionResultList": questionResultList == null
            ? null
            : List<dynamic>.from(questionResultList.map((x) => x.toMap())),
      };
}

//{
//"surveyId":"surveyId0",
//"questionResultList":[{"questionText":"","answerList":[{"answerText":"xtexs","ownerId":"ownerId"}]}]
//}
