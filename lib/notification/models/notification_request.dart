import 'dart:convert';

NotificationRequest notificationRequestFromJson(String str) => NotificationRequest.fromJson(json.decode(str));

String notificationRequestToJson(NotificationRequest data) => json.encode(data.toJson());

class NotificationRequest {
    String? token;
    int? index;
    int? count;

    NotificationRequest({
        this.token,
        this.index,
        this.count,
    });

    factory NotificationRequest.fromJson(Map<String, dynamic> json) => NotificationRequest(
        token: json["token"],
        index: json["index"],
        count: json["count"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "index": index,
        "count": count,
    };
}
