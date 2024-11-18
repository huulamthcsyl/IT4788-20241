import 'dart:convert';

import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<UserData> getUserData() async {
  const flutterSecureStorage = FlutterSecureStorage();
  final data = await flutterSecureStorage.read(key: 'user');
  List<int> dataBytes = List<int>.from(jsonDecode(data!));
  final dataDecoded = jsonDecode(utf8.decode(dataBytes));
  return UserData.fromJson(dataDecoded);
}