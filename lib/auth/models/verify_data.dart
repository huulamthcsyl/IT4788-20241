import 'dart:convert';

VerifyData verifyDataFromJson(String str) => VerifyData.fromJson(json.decode(str));

String verifyDataToJson(VerifyData data) => json.encode(data.toJson());

class VerifyData {
  String? email;
  String? verifyCode;

  VerifyData({
    this.email,
    this.verifyCode,
  });

  factory VerifyData.fromJson(Map<String, dynamic> json) => VerifyData(
    email: json["email"],
    verifyCode: json["verify_code"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "verify_code": verifyCode,
  };
}
