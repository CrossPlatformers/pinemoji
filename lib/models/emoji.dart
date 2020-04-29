// To parse this JSON data, do
//
//     final emoji = emojiFromJson(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:pinemoji/models/emoji_option.dart';
import 'package:pinemoji/models/emoji_state.dart';

Emoji emojiFromJson(String str) => Emoji.fromMap(json.decode(str));

String emojiToJson(Emoji data) => json.encode(data.toMap());

class Emoji {
  final String companyId;
  final String info;
  final String description;
  final List<EmojiState> stateList;
  final List<EmojiOption> optionList;

  Emoji({
    @required this.companyId,
    @required this.info,
    @required this.description,
    @required this.stateList,
    @required this.optionList,
  });

  Emoji copyWith({
    String companyId,
    String info,
    String description,
    List<EmojiState> stateList,
    List<EmojiOption> optionList,
  }) =>
      Emoji(
        companyId: companyId ?? this.companyId,
        info: info ?? this.info,
        description: description ?? this.description,
        stateList: stateList ?? this.stateList,
        optionList: optionList ?? this.optionList,
      );

  factory Emoji.fromMap(Map<String, dynamic> json) => Emoji(
        companyId: json["companyId"] == null ? null : json["companyId"],
        info: json["info"] == null ? null : json["info"],
        description: json["description"] == null ? null : json["description"],
        stateList: json["stateList"] == null
            ? null
            : List<EmojiState>.from(
                json["stateList"].map((x) => EmojiState.fromMap(x))),
        optionList: json["optionList"] == null
            ? null
            : List<EmojiOption>.from(
                json["optionList"].map((x) => EmojiOption.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "companyId": companyId == null ? null : companyId,
        "info": info == null ? null : info,
        "description": description == null ? null : description,
        "stateList": stateList == null
            ? null
            : List<dynamic>.from(stateList.map((x) => x.toMap())),
        "optionList": optionList == null
            ? null
            : List<dynamic>.from(optionList.map((x) => x.toMap())),
      };
}

//{
//"companyId": "id",
//"info": "info",
//"description": "info",
//"stateList": [
//{
//"id": "id",
//"name": "Avacado - Medium",
//"prerequest":["",""]
//}
//],
//"optionList": [{
//"name": "id",
//"color": "hex"
//}
//],
//"info": "info"
//}
