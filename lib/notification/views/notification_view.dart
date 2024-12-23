import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/notification/models/notification_data.dart';
import 'package:it4788_20241/notification/viewmodels/notification_viewmodel.dart';
import 'package:it4788_20241/notification/widgets/notification_tile.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final NotificationViewModel viewModel = context.read<NotificationViewModel>();
    viewModel.initNotification();
  }

  @override
  Widget build(BuildContext context) {
    final NotificationViewModel viewModel = context.watch<NotificationViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'THÔNG BÁO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.refresh,
        child: ListView.builder(
          itemCount: viewModel.notificationList.length,
          itemBuilder: (context, index) {
            final notification = viewModel.notificationList[index];
            return NotificationTile(
              notificationData: notification,
              // refresh: viewModel.refresh(),
            );
          },
        )
      ),
    );
  }
}