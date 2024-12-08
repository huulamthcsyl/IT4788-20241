import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:it4788_20241/chat/models/conversation_data.dart';
import 'package:it4788_20241/chat/viewmodels/chat_overview_viewmodel.dart';
import 'package:it4788_20241/chat/widgets/conversation_tile.dart';
import 'package:provider/provider.dart';

class ChatOverviewPage extends StatelessWidget {
  const ChatOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatOverviewViewModel viewModel = context.watch<ChatOverviewViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tin nhắn",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.refresh,
        child: PagedListView<int, ConversationData>(
          pagingController: viewModel.pagingController,
          builderDelegate: PagedChildBuilderDelegate<ConversationData>(
            itemBuilder: (context, item, index) => ConversationTile(
              conversationData: item,
            )
          ),
        ),
      )
    );
  }
}