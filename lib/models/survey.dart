// To parse this JSON data, do
//
//     final survey = surveyFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'package:pinemoji/models/question.dart';

Survey surveyFromJson(String str) => Survey.fromMap(json.decode(str));

String surveyToJson(Survey data) => json.encode(data.toMap());

class Survey {
  String id;
  final String companyId;
  final DateTime startDate;
  final DateTime endDate;
  final bool active;
  final String sendType;
  final String answerType;
  final List<Question> questionList;
  final String info;

  Survey({
    this.id,
    @required this.companyId,
    this.startDate,
    this.endDate,
    @required this.active,
    @required this.sendType,
    @required this.answerType,
    @required this.questionList,
    @required this.info,
  });

  Survey copyWith({
    String id,
    String companyId,
    String startDate,
    String endDate,
    bool active,
    String sendType,
    String answerType,
    List<Question> questionList,
    String info,
  }) =>
      Survey(
        id: id ?? this.id,
        companyId: companyId ?? this.companyId,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        active: active ?? this.active,
        sendType: sendType ?? this.sendType,
        answerType: answerType ?? this.answerType,
        questionList: questionList ?? this.questionList,
        info: info ?? this.info,
      );

  factory Survey.fromMap(Map<String, dynamic> json) => Survey(
        id: json["id"] == null ? null : json["id"],
        companyId: json["companyId"] == null ? null : json["companyId"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        active: json["active"] == null ? null : json["active"],
        sendType: json["sendType"] == null ? null : json["sendType"],
        answerType: json["answerType"] == null ? null : json["answerType"],
        questionList: json["questionList"] == null
            ? null
            : List<Question>.from(
                json["questionList"].map((x) => Question.fromMap(x))),
        info: json["info"] == null ? null : json["info"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "companyId": companyId == null ? null : companyId,
        "startDate": startDate == null ? null : startDate,
        "endDate": endDate == null ? null : endDate,
        "active": active == null ? null : active,
        "sendType": sendType == null ? null : sendType,
        "answerType": answerType == null ? null : answerType,
        "questionList": questionList == null
            ? null
            : List<dynamic>.from(questionList.map((x) => x.toMap())),
        "info": info == null ? null : info,
      };
}

//{
//"companyId": "id",
//"startDate":"",
//"endDate":"",
//"active":true,
//"sendType": "",
//"answerType": "",
//"questionList": [{
//"description": "id",
//"type": "hex",
//"answerList":""
//}
//],
//"info": "info"
//}
