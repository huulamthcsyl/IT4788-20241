import 'package:flutter/material.dart';
import 'package:it4788_20241/leave/models/leave_request_model.dart';
import 'package:intl/intl.dart';

class LeaveRequestDetailsDialog extends StatelessWidget {
  final LeaveRequest item;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const LeaveRequestDetailsDialog({
    Key? key,
    required this.item,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  String convertGoogleDriveLink(String link) {
    final regex = RegExp(r'd/([a-zA-Z0-9_-]+)/view');
    final match = regex.firstMatch(link);
    if (match != null && match.groupCount >= 1) {
      final fileId = match.group(1);
      return 'https://drive.google.com/uc?export=view&id=$fileId';
    }
    return link;
  }

  @override
  Widget build(BuildContext context) {
    // Format date
    final formattedDate = DateFormat('dd/MM/yyyy')
        .format(DateTime.parse(item.absenceDate).toLocal());

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Text(
                'Chi tiết đơn xin nghỉ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
            Divider(thickness: 1, height: 20),
            // Thông tin sinh viên
            Row(
              children: [
                Text(
                  'Sinh viên: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                      '${item.studentAccount.firstName} ${item.studentAccount.lastName}'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'MSSV: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(child: Text(item.studentAccount.studentId)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Email: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(child: Text(item.studentAccount.email)),
              ],
            ),
            Divider(thickness: 1, height: 20),
            // Thông tin đơn nghỉ
            Row(
              children: [
                Text(
                  'Tiêu đề: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(child: Text(item.title)),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lý do: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Text(
                      item.reason,
                      textAlign: TextAlign.justify,
                    )),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Ngày: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(child: Text(formattedDate)),
              ],
            ),
            SizedBox(height: 8),

            Text(
              'Ảnh minh chứng: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Center(
                  child: Image.network(
                    convertGoogleDriveLink(item.file),
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Không tải được ảnh',
                          style: TextStyle(color: Colors.red));
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Trạng thái: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    item.status == "PENDING"
                        ? "Chờ duyệt"
                        : item.status == "ACCEPTED"
                        ? "Chấp nhận"
                        : "Từ chối",
                    style: TextStyle(
                      color: item.status == "PENDING"
                          ? Colors.orange
                          : item.status == "ACCEPTED"
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Nút hành động
            if (item.status == "PENDING") ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onPressed: onAccept,
                    child: Text('Đồng ý', style: TextStyle(fontSize: 14)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onPressed: onReject,
                    child: Text('Từ chối', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ],
            SizedBox(height: 16),
            // Nút đóng
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                ),
                child: Text(
                  'Đóng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}