import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:it4788_20241/chat/models/conversation_data.dart';
import 'package:it4788_20241/chat/models/message_data.dart';
import 'package:it4788_20241/chat/viewmodels/conversation_viewmodel.dart';
import 'package:provider/provider.dart';

class ConversationPage extends StatelessWidget {
  final ConversationData conversationData;

  const ConversationPage({super.key, required this.conversationData});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ConversationViewModel>();
    viewModel.setConversationId(conversationData.id.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          conversationData.partner.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PagedListView<int, MessageData>(
              pagingController: viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<MessageData>(
                itemBuilder: (context, item, index) {
                  if (item.sender.id == conversationData.partner.id) {
                    return ListTile(
                      title: Text(item.message),
                      leading: CircleAvatar(
                        backgroundImage: conversationData.partner.avatar != null ? NetworkImage(conversationData.partner.avatar ?? "") : null,
                      ),
                    );
                  } else {
                    return ListTile(
                      title: Text(
                        item.message,
                        textAlign: TextAlign.right,
                      ),
                      trailing: CircleAvatar(
                        backgroundImage: conversationData.partner.avatar != null ? NetworkImage(conversationData.partner.avatar ?? "") : null,
                      ),
                    );
                  }
                }
              ),
            ),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.white,
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10)
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
