import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:it4788_20241/auth/models/login_data.dart';

import '../repositories/auth_respository.dart';

class AuthService {

  final _authRepository = AuthRepository();
  final storage = const FlutterSecureStorage();

  Future<void> login(LoginData loginData) async {
    final response = await _authRepository.login(loginData);
    storage.write(key: "token", value: response.token);
  }
}