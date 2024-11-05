import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  int id;
  dynamic ho;
  dynamic ten;
  String username;
  String token;
  String active;
  String role;
  dynamic avatar;

  UserData({
    required this.id,
    required this.ho,
    required this.ten,
    required this.username,
    required this.token,
    required this.active,
    required this.role,
    required this.avatar,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    ho: json["ho"],
    ten: json["ten"],
    username: json["username"],
    token: json["token"],
    active: json["active"],
    role: json["role"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ho": ho,
    "ten": ten,
    "username": username,
    "token": token,
    "active": active,
    "role": role,
    "avatar": avatar,
  };
}
