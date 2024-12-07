import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/auth/services/auth_service.dart';

class NotificationTileViewModel extends ChangeNotifier {

  final _authServices = AuthService();

  Future<UserData> getSenderInfo(String id) async {
    return await _authServices.getUserInfo(id);
  }
}
