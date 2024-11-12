import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  int id;
  String ho;
  String ten;
  String username;
  String token;
  String status;
  String role;
  String? avatar;

  UserData({
    required this.id,
    required this.ho,
    required this.ten,
    required this.username,
    required this.token,
    required this.status,
    required this.role,
    required this.avatar,
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