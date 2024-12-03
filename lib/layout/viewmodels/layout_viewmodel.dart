import 'package:flutter/foundation.dart';
import 'package:it4788_20241/notification/services/notification_services.dart';

class LayoutViewModel extends ChangeNotifier {
  int unreadNotificationCount = 0;
  int currentPageIndex = 0;
  final _notificationServices = NotificationServices();

  LayoutViewModel() {
    getUnreadNotificationCount();
  }

  void getUnreadNotificationCount() async {
    final count = await _notificationServices.getUnreadNotificationCount();
    unreadNotificationCount = count;
    notifyListeners();
  }

  void updateCurrentPageIndex(int index) {
    currentPageIndex = index;
    notifyListeners();
  }
}
