import 'dart:io';

import 'package:it4788_20241/notification/models/notification_data.dart';
import 'package:it4788_20241/notification/models/notification_request.dart';
import 'package:it4788_20241/notification/repositories/notification_repository.dart';
import 'package:it4788_20241/utils/get_data_user.dart';

class NotificationServices {
  final _notificationRepository = NotificationRepository();

  Future<int> getUnreadNotificationCount() async {
    final token = (await getUserData()).token;
    if (token == null) return 0;
    final unreadNotificationCount = await _notificationRepository.getUnreadNotificationCount(token);
    return unreadNotificationCount;
  }

  Future<List<NotificationData>> getNotifications(int index, int count) async {
    final token = (await getUserData()).token;
    final notificationRequest = NotificationRequest(
      token: token,
      index: index,
      count: count,
    );
    final notifications = await _notificationRepository.getNotifications(notificationRequest);
    return notifications;
  }

  Future<void> markAsRead(String notificationId) async {
    final token = (await getUserData()).token;
    if (token == null) return;
    await _notificationRepository.markAsRead(token, notificationId);
  }

  Future<void> sendNotification(String message, String toUser, File? image, String type) async {
    final token = (await getUserData()).token;
    if (token == null) return;
    await _notificationRepository.sendNotification(token, message, toUser, image, type);
  }
}