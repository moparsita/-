// To parse this JSON data, do
//
//     final inviteModel = inviteModelFromJson(jsonString);

import 'dart:convert';

InviteModel inviteModelFromJson(String str) => InviteModel.fromJson(json.decode(str));

String inviteModelToJson(InviteModel data) => json.encode(data.toJson());

class InviteModel {
  InviteModel({
    required this.id,
    required this.title,
    required this.text,
    required this.link,
    required this.chooser,
  });

  int id;
  String title;
  String text;
  String link;
  String chooser;

  factory InviteModel.fromJson(Map<String, dynamic> json) => InviteModel(
    id: json["id"],
    title: json["title"],
    text: json["text"],
    link: json["link"],
    chooser: json["chooser"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "text": text,
    "link": link,
    "chooser": chooser,
  };
}
