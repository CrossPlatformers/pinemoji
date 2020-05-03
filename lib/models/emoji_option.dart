// To parse this JSON data, do
//
//     final emojiOption = emojiOptionFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

EmojiOption emojiOptionFromJson(String str) => EmojiOption.fromMap(json.decode(str));

String emojiOptionToJson(EmojiOption data) => json.encode(data.toMap());

class EmojiOption {
  final String name;
  final String color;

  EmojiOption({
    @required this.name,
    @required this.color,
  });

  EmojiOption copyWith({
    String name,
    String color,
  }) =>
      EmojiOption(
        name: name ?? this.name,
        color: color ?? this.color,
      );

  factory EmojiOption.fromMap(Map<String, dynamic> json) => EmojiOption(
    name: json["name"] == null ? null : json["name"],
    color: json["color"] == null ? null : json["color"],
  );

  Map<String, dynamic> toMap() => {
    "name": name == null ? null : name,
    "color": color == null ? null : color,
  };
}


//{
//"name": "id",
//"color": "hex"
//}
