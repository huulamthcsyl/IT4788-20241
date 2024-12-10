import 'dart:convert';

PartnerData senderDataFromJson(String str) =>
    PartnerData.fromJson(json.decode(str));

String senderDataToJson(PartnerData data) => json.encode(data.toJson());

class PartnerData {
  int id;
  String name;
  String? avatar;

  PartnerData({
    required this.id,
    required this.name,
    this.avatar,
  });

  factory PartnerData.fromJson(Map<String, dynamic> json) => PartnerData(
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
