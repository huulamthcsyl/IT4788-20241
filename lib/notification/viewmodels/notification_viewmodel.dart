import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/auth/services/auth_service.dart';
import 'package:it4788_20241/notification/models/notification_data.dart';
import 'package:it4788_20241/notification/services/notification_services.dart';

class NotificationViewModel extends ChangeNotifier {
  int currentNotificationIndex = 0;
  final notificationPageSize = 5;

  final _notificationServices = NotificationServices();
  final _authServices = AuthService();

  final pagingController = PagingController<int, NotificationData>(
    firstPageKey: 0,
  );

  NotificationViewModel() {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await _notificationServices.getNotifications(pageKey, notificationPageSize);
      final isLastPage = newItems.length < notificationPageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  Future<void> refresh() async {
    pagingController.refresh();
  }

  Future<UserData> getUserInfo(String id) async {
    return await _authServices.getUserInfo(id);
  }
}
