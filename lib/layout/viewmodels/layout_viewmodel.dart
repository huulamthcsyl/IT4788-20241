import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:it4788_20241/chat/services/chat_service.dart';
import 'package:it4788_20241/notification/services/notification_services.dart';

class LayoutViewModel extends ChangeNotifier {
  int unreadNotificationCount = 0;
  int currentPageIndex = 0;
  int unreadMessageCount = 0;
  final _notificationServices = NotificationServices();
  final _chatServices = ChatService();

  LayoutViewModel() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      getUnreadNotificationCount();
    });
    getUnreadNotificationCount();
    getUnreadMessageCount();
  }

  void init(){
    getUnreadNotificationCount();
    getUnreadMessageCount();
  }

  void getUnreadNotificationCount() async {
    final notificationCount = await _notificationServices.getUnreadNotificationCount();
    unreadNotificationCount = notificationCount;
    notifyListeners();
  }

  void getUnreadMessageCount() async {
    final messageCount = await _chatServices.getUnreadMessageCount();
    unreadMessageCount = messageCount;
    notifyListeners();
  }

  void decreaseUnreadNotificationCount() {
    unreadNotificationCount--;
    notifyListeners();
  }

  void decreaseUnreadMessageCount() {
    unreadMessageCount--;
    notifyListeners();
  }

  void updateCurrentPageIndex(int index) {
    currentPageIndex = index;
    notifyListeners();
  }
}
