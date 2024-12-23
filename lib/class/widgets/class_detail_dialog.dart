import 'package:flutter/material.dart';
import '../models/class_model.dart';

class ClassDetailsDialog extends StatelessWidget {
  final ClassInfo classInfo;

  const ClassDetailsDialog({Key? key, required this.classInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Chi tiết lớp học', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 16),
            Text('Mã lớp: ${classInfo.class_id}'),
            Text('Mã lớp kèm: ${classInfo.attached_code}'),
            Text('Tên lớp: ${classInfo.class_name}'),
            Text('Giảng viên: ${classInfo.lecturer_name}'),
            Text('Số lượng SV: ${classInfo.student_count}'),
            Text('Ngày bắt đầu: ${classInfo.start_date}'),
            Text('Ngày kết thúc: ${classInfo.end_date}'),
            Text('Loại lớp: ${classInfo.class_type}'),
            Text('Trạng thái: ${classInfo.status}'),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Đóng', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
