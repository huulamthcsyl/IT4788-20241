import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  int? id;
  String? ho;
  String? ten;
  String? username;
  String? token;
  String? status;
  String? role;
  String? avatar;

  UserData({
    this.id,
    this.ho,
    this.ten,
    this.username,
    this.token,
    this.status,
    this.role,
    this.avatar,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    ho: json["ho"],
    ten: json["ten"],
    username: json["user_name"],
    token: json["token"],
    status: json["status"],
    role: json["role"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ho": ho,
    "ten": ten,
    "user_name": username,
    "token": token,
    "status": status,
    "role": role,
    "avatar": avatar,
  };
}
