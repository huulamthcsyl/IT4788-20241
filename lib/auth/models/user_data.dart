import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  String id;
  String ho;
  String ten;
  String name;
  String? token;
  String status;
  String role;
  String? avatar;
  String email;
  UserData({
    required this.id,
    required this.ho,
    required this.ten,
    required this.name,
    this.token,
    required this.email,
    required this.status,
    required this.role,
    this.avatar,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["id"],
    ho: json["ho"],
    ten: json["ten"],
    name: json["name"],
    email: json["email"],
    token: json["token"],
    status: json["status"],
    role: json["role"],
    avatar: json["avatar"],
  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "ho": ho,
    "ten": ten,
    "name": name,
    "email": email,
    "token": token,
    "status": status,
    "role": role,
    "avatar": avatar,
  };
}
