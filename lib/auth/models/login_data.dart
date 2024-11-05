import 'dart:convert';

LoginData loginDataFromJson(String str) => LoginData.fromJson(json.decode(str));

String loginDataToJson(LoginData data) => json.encode(data.toJson());

class LoginData {
  String email;
  String password;
  String deviceId;

  LoginData({
    required this.email,
    required this.password,
    required this.deviceId,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    email: json["email"],
    password: json["password"],
    deviceId: json["deviceId"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "deviceId": deviceId,
  };
}
