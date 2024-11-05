import 'dart:convert';

import 'package:it4788_20241/auth/models/login_data.dart';
import 'package:it4788_20241/auth/models/user_data.dart';

import 'package:http/http.dart' as http;
import 'package:it4788_20241/const/api.dart';

class AuthRepository {
  Future<UserData> login(LoginData loginData) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it4788/login');
    final response = await http.post(httpUrl, body: jsonEncode(loginData.toJson()), headers: {
      'Content-Type': 'application/json',
    });
    if(response.statusCode == 200) {
      return UserData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Tài khoản hoặc mật khẩu không đúng");
    }
  }
}