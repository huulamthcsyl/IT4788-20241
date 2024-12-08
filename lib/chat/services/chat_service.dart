import 'package:it4788_20241/chat/models/conversation_data.dart';
import 'package:it4788_20241/chat/models/conversation_request.dart';
import 'package:it4788_20241/chat/models/list_conversation_request.dart';
import 'package:it4788_20241/chat/models/message_data.dart';
import 'package:it4788_20241/chat/repositories/chat_repository.dart';
import 'package:it4788_20241/utils/get_data_user.dart';

class ChatService {
  final ChatRepository _chatRepository = ChatRepository();

  Future<List<ConversationData>> getListConversation(
      int index, int count) async {
    final token = (await getUserData()).token;
    if (token == null) return [];
    final request = ListConversationRequest(
      token: token,
      index: index,
      count: count,
    );
    return await _chatRepository.getListConversation(request);
  }

  Future<List<MessageData>> getConversation(String conversationId, int index, int count) async {
    final token = (await getUserData()).token;
    if (token == null) return [];
    final request = ConversationRequest(
      conversationId: conversationId,
      token: token,
      index: index,
      count: count,
      markAsRead: true,
    );
    return await _chatRepository.getConversation(request);
  }
}
