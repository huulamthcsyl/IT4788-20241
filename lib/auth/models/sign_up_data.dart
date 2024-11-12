import 'dart:convert';

SignUpData signUpDataFromJson(String str) => SignUpData.fromJson(json.decode(str));

String signUpDataToJson(SignUpData data) => json.encode(data.toJson());

class SignUpData {
  String? ho;
  String? ten;
  String? email;
  String? password;
  String? role;

  SignUpData({
    this.ho,
    this.ten,
    this.email,
    this.password,
    this.role,
  });

  factory SignUpData.fromJson(Map<String, dynamic> json) => SignUpData(
    ho: json["ho"],
    ten: json["ten"],
    email: json["email"],
    password: json["password"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "ho": ho,
    "ten": ten,
    "email": email,
    "password": password,
    "role": role,
  };
}
