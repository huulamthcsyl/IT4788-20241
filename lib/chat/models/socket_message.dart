import 'package:it4788_20241/chat/models/sender_data.dart';
import 'dart:convert';

SocketMessage socketMessageFromJson(String str) => SocketMessage.fromJson(json.decode(str));

String socketMessageToJson(SocketMessage data) => json.encode(data.toJson());

class SocketMessage {
  int id;
  PartnerData sender;
  PartnerData receiver;
  int conversationId;
  String content;
  DateTime createdAt;
  int messageStatus;

  SocketMessage({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.conversationId,
    required this.content,
    required this.createdAt,
    required this.messageStatus,
  });

  factory SocketMessage.fromJson(Map<String, dynamic> json) => SocketMessage(
    id: json["id"],
    sender: PartnerData.fromJson(json["sender"]),
    receiver: PartnerData.fromJson(json["receiver"]),
    conversationId: json["conversation_id"],
    content: json["content"],
    createdAt: DateTime.parse(json["created_at"]),
    messageStatus: json["message_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sender": sender.toJson(),
    "receiver": receiver.toJson(),
    "conversation_id": conversationId,
    "content": content,
    "created_at": createdAt.toIso8601String(),
    "message_status": messageStatus,
  };
}
