// To parse this JSON data, do
//
//     final answer = answerFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Answer answerFromJson(String str) => Answer.fromMap(json.decode(str));

String answerToJson(Answer data) => json.encode(data.toMap());



class Answer {
    final String answerText;
    final String emojiText;
    String otherInfo;
    final Map<String, String> ownerList;
    
    Answer({
        @required this.answerText,
        @required this.emojiText,
        @required this.otherInfo,
        @required this.ownerList,
    });

    Answer copyWith({
        String answerText,
        String emojiText,
        String otherInfo,
        Map<String, String> ownerList,
    }) => 
        Answer(
            answerText: answerText ?? this.answerText,
            emojiText: emojiText ?? this.emojiText,
            otherInfo: otherInfo ?? this.otherInfo,
            ownerList: ownerList ?? this.ownerList,
        );

    factory Answer.fromMap(Map<String, dynamic> json) => Answer(
        answerText: json["answerText"] == null ? null : json["answerText"],
        emojiText: json["emojiText"] == null ? null : json["emojiText"],
        otherInfo: json["otherInfo"] == null ? null : json["otherInfo"],
        ownerList: Map.from(json["ownerList"]).map((k, v) => MapEntry<String, String>(k, v)),
    );

    Map<String, dynamic> toMap() => {
        "answerText": answerText == null ? null : answerText,
        "emojiText": emojiText == null ? null : emojiText,
        "otherInfo": otherInfo == null ? null : otherInfo,
        "ownerList": Map.from(ownerList).map((k, v) => MapEntry<String, dynamic>(k, v)),
    };
}


// {"answerText":"xtexs","ownerId":"ownerId","location":"location"}
