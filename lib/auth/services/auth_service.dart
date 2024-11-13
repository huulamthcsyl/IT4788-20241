import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:it4788_20241/auth/models/login_data.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:it4788_20241/auth/models/sign_up_data.dart';

import '../repositories/auth_respository.dart';

class AuthService {

  final _authRepository = AuthRepository();
  final storage = const FlutterSecureStorage();

  Future<void> login(LoginData loginData) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    loginData.deviceId = androidInfo.id;
    final response = await _authRepository.login(loginData);
    storage.write(key: "token", value: response.token);
  }

  Future<void> signUp(SignUpData signUpData) async {
    await _authRepository.signUp(signUpData);
  }

  Future<void> logout() async {
    await storage.delete(key: "token");
  }
}