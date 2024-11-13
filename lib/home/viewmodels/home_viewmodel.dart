import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:it4788_20241/auth/models/user_data.dart';

class HomeViewModel extends ChangeNotifier {

  final _flutterSecureStorage = const FlutterSecureStorage();
  UserData userData = UserData();

  HomeViewModel() {
    // getUserData();
  }

  void getUserData() async {
    final data = await _flutterSecureStorage.read(key: 'user');
    final dataDecoded = jsonDecode(data!);
    userData = UserData.fromJson(dataDecoded);
    notifyListeners();
  }
}