import 'package:flutter/material.dart';
import 'package:it4788_20241/notification/models/notification_data.dart';
import 'package:it4788_20241/notification/viewmodels/notification_tile_viewmodel.dart';
import 'package:it4788_20241/notification/views/notification_detail_view.dart';
import 'package:it4788_20241/types/notification_type.dart';
import 'package:it4788_20241/utils/time_from_now.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationTile extends StatelessWidget {
  final NotificationData notificationData;

  const NotificationTile({
    super.key,
    required this.notificationData,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationTileViewModel>();
    return FutureBuilder(
      future: viewModel.getSenderInfo(notificationData.fromUser.toString()),
      builder: (context, snapshot) { 
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationDetailView(
                notificationData: notificationData, 
                senderInfo: snapshot.data,
              ))
            ),
            child: ListTile(
              title: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                  children: <TextSpan>[
                    TextSpan(text: snapshot.data?.name ?? ""),
                    const TextSpan(text: " đã gửi một thông báo ", style: TextStyle(fontWeight: FontWeight.normal)),
                    TextSpan(text: notificationTypeLabel[notificationData.type])
                  ]
                )
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notificationData.message),
                  Text(
                    fromNow(notificationData.sentTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: notificationData.status == "UNREAD"
                          ? Colors.red
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
              tileColor: notificationData.status == "UNREAD" ? Colors.grey[200] : null,
            ),
          );
        } else {
          return const Skeletonizer(
            child: ListTile(
              title: Text(""),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(""),
                  Text(""),
                ],
              ),
            ),
          );
        }
      }
    );
  }
}
