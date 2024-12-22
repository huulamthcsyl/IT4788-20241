import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getFirebaseToken() async {
    await _firebaseMessaging.requestPermission();
    return await _firebaseMessaging.getToken();
  }
}