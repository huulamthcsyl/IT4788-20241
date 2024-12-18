import 'dart:convert';

ListConversationRequest conversationRequestFromJson(String str) => ListConversationRequest.fromJson(json.decode(str));

String conversationRequestToJson(ListConversationRequest data) => json.encode(data.toJson());

class ListConversationRequest {
  String token;
  int index;
  int count;

  ListConversationRequest({
    required this.token,
    required this.index,
    required this.count,
  });

  factory ListConversationRequest.fromJson(Map<String, dynamic> json) => ListConversationRequest(
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
