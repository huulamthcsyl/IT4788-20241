import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/auth/services/auth_service.dart';
import 'package:it4788_20241/notification/models/notification_data.dart';
import 'package:it4788_20241/notification/services/notification_services.dart';

import '../../layout/viewmodels/layout_viewmodel.dart';

class NotificationViewModel extends ChangeNotifier {
  final _notificationServices = NotificationServices();
  final _authServices = AuthService();
  final _layoutViewModel = LayoutViewModel();
  final notificationList = <NotificationData>[];


  NotificationViewModel() {
    initNotification();
  }

  void initNotification() {
    _layoutViewModel.getUnreadMessageCount();
    fetchNotification();
  }

  Future<void> fetchNotification() async {
    final newItems = await _notificationServices.getNotifications(0, 1000);
    notificationList.clear();
    notificationList.addAll(newItems);
    notifyListeners();
  }

  Future<void> refresh() async {
    _layoutViewModel.getUnreadMessageCount();
    fetchNotification();
  }

  Future<UserData> getUserInfo(String id) async {
    return await _authServices.getUserInfo(id);
  }
}
