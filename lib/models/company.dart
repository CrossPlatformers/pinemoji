// To parse this JSON data, do
//
//     final company = companyFromJson(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

Company companyFromJson(String str) => Company.fromMap(json.decode(str));

String companyToJson(Company data) => json.encode(data.toMap());

class Company {
  final String id;
  final String name;
  final String title;
  final String taxNo;

  Company({
    @required this.id,
    @required this.name,
    @required this.title,
    @required this.taxNo,
  });

  Company copyWith({
    String id,
    String name,
    String title,
    String taxNo,
  }) =>
      Company(
        id: id ?? this.id,
        name: name ?? this.name,
        title: title ?? this.title,
        taxNo: taxNo ?? this.taxNo,
      );

  factory Company.fromMap(Map<String, dynamic> json) => Company(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        title: json["title"] == null ? null : json["title"],
        taxNo: json["taxNo"] == null ? null : json["taxNo"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "title": title == null ? null : title,
        "taxNo": taxNo == null ? null : taxNo,
      };
}


//{
//"id": "id",
//"name": "Avacado - Medium",
//"title":"",
//"taxNo":""
//}
