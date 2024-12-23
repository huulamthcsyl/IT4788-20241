import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:it4788_20241/auth/models/login_data.dart';
import 'package:it4788_20241/auth/models/sign_up_data.dart';
import 'package:it4788_20241/auth/models/user_data.dart';

import 'package:http/http.dart' as http;
import 'package:it4788_20241/auth/models/verify_data.dart';
import 'package:it4788_20241/const/api.dart';
import 'package:it4788_20241/exceptions/GlobalException.dart';
import 'package:it4788_20241/utils/show_notification.dart';
import 'package:mime/mime.dart';

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
  Future<void> changeAvatar({
    required String token,
    required File file,
  }) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it4788/change_info_after_signup');
    final mimeType = lookupMimeType(file.path);
    if (mimeType == null) {
      throw Exception("Không xác định được MIME type của file");
    }

    var request = http.MultipartRequest('POST', httpUrl);

    request.files.add(
      http.MultipartFile(
        'file',
        File(file.path).readAsBytes().asStream(),
        File(file.path).lengthSync(),
        filename: file.path.split('/').last,
      ),
    );
    request.fields['token'] = token;
    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print("Đổi ảnh đại diện thành công: $responseBody");

      var responseJson = jsonDecode(responseBody);

      if (responseJson['data'] is Map<String, dynamic>) {
        String newAvatarUrl = responseJson['data']['avatar'];

        final flutterSecureStorage = FlutterSecureStorage();
        String? storedUserData = await flutterSecureStorage.read(key: 'user');

        if (storedUserData != null) {
          List<int> dataBytes = List<int>.from(jsonDecode(storedUserData));
          final dataDecoded = jsonDecode(utf8.decode(dataBytes));
          dataDecoded['avatar'] = newAvatarUrl;
          print(dataDecoded['avatar']);
          await flutterSecureStorage.write(
            key: 'user',
            value: utf8.encode(jsonEncode(dataDecoded)).toString(),
          );
          showNotification("Đổi ảnh đại diện thành công", Colors.green.withOpacity(0.9));
        }
      } else {
        showNotification("Đổi mật khẩu thất bại [1]", Colors.green.withOpacity(0.9));
      }
    } catch (e) {
      showNotification("Đổi ảnh đại diện tht bại [2]", Colors.green.withOpacity(0.9));
    }
  }
  Future<void> changePassword({
    required String? token,
    required String old_password,
    required String new_password,
  }) async {
    final httpUrl = Uri.http(BASE_API_URL, '/it4788/change_password');
    final Map<String, dynamic> body = {
      "token": token,
      "old_password": old_password,
      "new_password": new_password,
    };
    try {
      final response = await http.post(
        httpUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "$token"
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        showNotification("Đổi mật khẩu thành công", Colors.green.withOpacity(0.9));
      } else {
        showNotification("Đổi mật khẩu thất bại [1]", Colors.red.withOpacity(0.9));
      }
    } catch (e) {
      showNotification("Đổi mật khẩu thất bại [2]", Colors.red.withOpacity(0.9));
    }
  }
}