import 'dart:convert';

SenderData senderDataFromJson(String str) => SenderData.fromJson(json.decode(str));

String senderDataToJson(SenderData data) => json.encode(data.toJson());

class SenderData {
  int id;
  String name;
  String? avatar;

  SenderData({
    required this.id,
    required this.name,
    this.avatar,
  });

  factory SenderData.fromJson(Map<String, dynamic> json) => SenderData(
    id: json["id"],
    name: json["name"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
  };
}
