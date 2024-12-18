import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:it4788_20241/chat/models/conversation_data.dart';
import 'package:it4788_20241/chat/viewmodels/chat_overview_viewmodel.dart';
import 'package:it4788_20241/chat/views/conversation_view.dart';
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
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Autocomplete(
              optionsBuilder: (TextEditingValue textEditingValue) async {
                final options = await viewModel.getSearchResult(textEditingValue.text);
                final result = options.map((e) => "${e.first_name} ${e.last_name} (${e.email} - ${e.account_id})").toList();
                return result;
              },
              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.all(8),
                  ),
                );
              },
              onSelected: (value) async {
                final partnerId = value.substring(value.indexOf("-") + 2, value.length - 1);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ConversationPage(partnerId: int.parse(partnerId))
                  )
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 64.0),
            child: RefreshIndicator(
              onRefresh: viewModel.refresh,
              child: PagedListView<int, ConversationData>(
                pagingController: viewModel.pagingController,
                builderDelegate: PagedChildBuilderDelegate<ConversationData>(
                  itemBuilder: (context, item, index) => ConversationTile(
                    conversationData: item,
                  )
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}