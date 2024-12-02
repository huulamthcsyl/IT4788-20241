import 'dart:convert';

NotificationData notificationDataFromJson(String str) => NotificationData.fromJson(json.decode(str));

String notificationDataToJson(NotificationData data) => json.encode(data.toJson());

class NotificationData {
    int id;
    String message;
    String status;
    int fromUser;
    int toUser;
    String type;
    DateTime sentTime;
    Data data;
    String titlePushNotification;

    NotificationData({
      required this.id,
      required this.message,
      required this.status,
      required this.fromUser,
      required this.toUser,
      required this.type,
      required this.sentTime,
      required this.data,
      required this.titlePushNotification,
    });

    factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
        id: json["id"],
        message: json["message"],
        status: json["status"],
        fromUser: json["from_user"],
        toUser: json["to_user"],
        type: json["type"],
        sentTime: DateTime.parse(json["sent_time"]),
        data: Data.fromJson(json["data"]),
        titlePushNotification: json["title_push_notification"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "status": status,
        "from_user": fromUser,
        "to_user": toUser,
        "type": type,
        "sent_time": sentTime.toIso8601String(),
        "data": data.toJson(),
        "title_push_notification": titlePushNotification,
    };
}

class Data {
    String? type;
    String? id;

    Data({
        this.type,
        this.id,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        type: json["type"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
    };
}
