import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:it4788_20241/auth/models/user_data.dart';

import '../../utils/get_data_user.dart';

class HomeViewModel extends ChangeNotifier {

  final _flutterSecureStorage = const FlutterSecureStorage();
  UserData userData = UserData();

  HomeViewModel() {
    initUserData();
  }

  void initUserData() async {
    userData = await getUserData();
    notifyListeners();
  }
}