import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:it4788_20241/auth/models/login_data.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:it4788_20241/auth/models/sign_up_data.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/utils/get_data_user.dart';

import '../repositories/auth_respository.dart';

class AuthService {
  final _authRepository = AuthRepository();
  final storage = const FlutterSecureStorage();

  Future<void> login(LoginData loginData) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    loginData.deviceId = androidInfo.id;
    final response = await _authRepository.login(loginData);
    storage.write(
        key: 'user',
        value: utf8.encode(jsonEncode(response.toJson())).toString());
  }
  Future<void> changeAvatar({
    required String token,
    required File file
  })async{
    await _authRepository.changeAvatar(token: token, file: file);
  }
  Future<void> signUp(SignUpData signUpData) async {
    await _authRepository.signUp(signUpData);
  }
  Future<void> changePassword({
    required String? token,
    required String old_password,
    required String new_password,
  }) async{
    await _authRepository.changePassword(token: token, old_password: old_password, new_password: new_password);
  }
  Future<void> logout() async {
    await storage.delete(key: "user");
  }

  Future<UserData> getUserInfo(String id) async {
    final token = (await getUserData()).token ?? "";
    return await _authRepository.getUserInfo(id, token);
  }
}
