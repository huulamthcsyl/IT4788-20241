import 'dart:convert';

import 'package:it4788_20241/auth/models/login_data.dart';
import 'package:it4788_20241/auth/models/sign_up_data.dart';
import 'package:it4788_20241/auth/models/user_data.dart';

import 'package:http/http.dart' as http;
import 'package:it4788_20241/auth/models/verify_data.dart';
import 'package:it4788_20241/const/api.dart';
import 'package:it4788_20241/exceptions/GlobalException.dart';

class AuthRepository {
  Future<UserData> login(LoginData loginData) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it4788/login');
    final response = await http.post(httpUrl, body: jsonEncode(loginData.toJson()), headers: {
      'Content-Type': 'application/json',
    });
    if(response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body['code'] == "1000") {
        return UserData.fromJson(body['data']);
      } else {
        throw GlobalException(body['message']);
      }
    } else {
      throw GlobalException("Tài khoản hoặc mật khẩu không đúng");
    }
  }

  Future<void> signUp(SignUpData signUpData) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it4788/signup');
    final response = await http.post(httpUrl, body: jsonEncode(signUpData.toJson()), headers: {
      'Content-Type': 'application/json',
    });
    final body = jsonDecode(response.body);
    if(response.statusCode == 200) {
      if (body['code'] == "1000") {
        final verifyData = VerifyData(email: signUpData.email, verifyCode: body['verify_code']);
        verifyAccount(verifyData);
      } else {
        throw GlobalException(body['message']);
      }
    } else {
      throw GlobalException(body['message']);
    }
  }

  Future<void> verifyAccount(VerifyData verifyData) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it4788/check_verify_code');
    final response = await http.post(httpUrl, body: jsonEncode(verifyData.toJson()), headers: {
      'Content-Type': 'application/json',
    });
    final body = jsonDecode(response.body);
    if(response.statusCode == 200) {
      if (body['code'] == "1000") {
        return;
      } else {
        throw GlobalException(body['message']);
      }
    } else {
      throw GlobalException(body['message']);
    }
  }

  Future<UserData> getUserInfo(String id, String token) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it4788/get_user_info');
    final response = await http.post(httpUrl, body: jsonEncode({"user_id": id, "token": token}), headers: {
      'Content-Type': 'application/json',
    });
    final body = jsonDecode(utf8.decode(response.bodyBytes));
    if(response.statusCode == 200) {
      if (body['code'] == "1000") {
        return UserData.fromJson(body['data']);
      } else {
        throw GlobalException(body['message']);
      }
    } else {
      throw GlobalException(body['message']);
    }
  }
}