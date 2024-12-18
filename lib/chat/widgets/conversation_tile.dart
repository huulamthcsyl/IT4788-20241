import 'package:flutter/material.dart';
import 'package:it4788_20241/chat/models/conversation_data.dart';
import 'package:it4788_20241/layout/viewmodels/layout_viewmodel.dart';
import 'package:it4788_20241/utils/time_from_now.dart';
import 'package:it4788_20241/chat/views/conversation_view.dart';
import 'package:provider/provider.dart';

class ConversationTile extends StatelessWidget {
  final ConversationData conversationData;

  const ConversationTile({super.key, required this.conversationData});

  @override
  Widget build(BuildContext context) {
    final layoutViewModel = context.read<LayoutViewModel>();
    return GestureDetector(
      onTap: () {
        if(conversationData.lastMessage.unread == 1){
          layoutViewModel.decreaseUnreadMessageCount();
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ConversationPage(conversationData: conversationData)
          )
        );
      },
      child: ListTile(
        title: Text(
          conversationData.partner.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(conversationData.lastMessage.message),
            Text(
              fromNow(conversationData.lastMessage.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: conversationData.lastMessage.sender.id == conversationData.partner.id
                    ? Colors.red
                    : Colors.grey,
              ),
            )
          ],
        ),
        leading: CircleAvatar(
          backgroundImage: conversationData.partner.avatar != null ? NetworkImage(conversationData.partner.avatar ?? "") : null,
        ),
      ),
    );
  }
}