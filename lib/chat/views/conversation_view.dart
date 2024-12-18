import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:it4788_20241/chat/models/message_data.dart';
import 'package:it4788_20241/chat/viewmodels/conversation_viewmodel.dart';
import 'package:provider/provider.dart';

class ConversationPage extends StatelessWidget {
  final int partnerId;

  const ConversationPage({super.key, required this.partnerId});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ConversationViewModel>();
    viewModel.setConversationInfo(partnerId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          viewModel.partnerData.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PagedListView<int, MessageData>(
              reverse: true,
              pagingController: viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<MessageData>(
                itemBuilder: (context, item, index) {
                  if (item.sender.id == partnerId) {
                    return ListTile(
                      title: Text(item.message ?? ""),
                      leading: CircleAvatar(
                        backgroundImage: viewModel.partnerData.avatar != null ? NetworkImage(viewModel.partnerData.avatar ?? "") : null,
                      ),
                    );
                  } else {
                    return ListTile(
                      title: Text(
                        item.message ?? "",
                        textAlign: TextAlign.right,
                      ),
                      trailing: CircleAvatar(
                        backgroundImage: viewModel.partnerData.avatar != null ? NetworkImage(viewModel.partnerData.avatar ?? "") : null,
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
                Expanded(
                  child: TextField(
                    controller: viewModel.messageTextController,
                    decoration: const InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10)
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.red,
                  ),
                  onPressed: viewModel.sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
