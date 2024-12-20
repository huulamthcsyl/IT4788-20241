import 'dart:convert';

LoginData loginDataFromJson(String str) => LoginData.fromJson(json.decode(str));

String loginDataToJson(LoginData data) => json.encode(data.toJson());

class LoginData {
  String email;
  String password;
  String deviceId;
  String? fcmToken;

  LoginData({
    required this.email,
    required this.password,
    required this.deviceId,
    this.fcmToken
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    email: json["email"],
    password: json["password"],
    deviceId: json["device_id"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "device_id": deviceId,
    "fcm_token": fcmToken
  };
}
