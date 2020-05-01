// To parse this JSON data, do
//
//     final emojiState = emojiStateFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

EmojiState emojiStateFromJson(String str) => EmojiState.fromMap(json.decode(str));

String emojiStateToJson(EmojiState data) => json.encode(data.toMap());

class EmojiState {
  final String id;
  final String name;
  final List<String> prerequest;

  EmojiState({
    @required this.id,
    @required this.name,
    @required this.prerequest,
  });

  EmojiState copyWith({
    String id,
    String name,
    List<String> prerequest,
  }) =>
      EmojiState(
        id: id ?? this.id,
        name: name ?? this.name,
        prerequest: prerequest ?? this.prerequest,
      );

  factory EmojiState.fromMap(Map<String, dynamic> json) => EmojiState(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    prerequest: json["prerequest"] == null ? null : List<String>.from(json["prerequest"].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "prerequest": prerequest == null ? null : List<dynamic>.from(prerequest.map((x) => x)),
  };
}

//{
//"id": "id",
//"name": "Avacado - Medium",
//"prerequest":["",""]
//}
