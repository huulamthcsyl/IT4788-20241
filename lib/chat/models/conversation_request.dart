import 'dart:convert';

ConversationRequest conversationRequestFromJson(String str) => ConversationRequest.fromJson(json.decode(str));

String conversationRequestToJson(ConversationRequest data) => json.encode(data.toJson());

class ConversationRequest {
    String token;
    int index;
    int count;
    String conversationId;
    bool markAsRead;

    ConversationRequest({
        required this.token,
        required this.index,
        required this.count,
        required this.conversationId,
        required this.markAsRead,
    });

    factory ConversationRequest.fromJson(Map<String, dynamic> json) => ConversationRequest(
        token: json["token"],
        index: json["index"],
        count: json["count"],
        conversationId: json["conversation_id"],
        markAsRead: json["mark_as_read"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "index": index,
        "count": count,
        "conversation_id": conversationId,
        "mark_as_read": markAsRead,
    };
}
