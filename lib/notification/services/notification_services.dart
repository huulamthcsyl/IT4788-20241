import 'package:it4788_20241/notification/models/notification_data.dart';
import 'package:it4788_20241/notification/models/notification_request.dart';
import 'package:it4788_20241/notification/repositories/notification_repository.dart';
import 'package:it4788_20241/utils/get_data_user.dart';

class NotificationServices {

  final _notificationRepository = NotificationRepository();

  Future<int> getUnreadNotificationCount() async {
    final token = (await getUserData()).token;
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
}