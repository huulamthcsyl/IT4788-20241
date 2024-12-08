import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';

class ClassDetailPage extends StatelessWidget {
  final ClassData classData;

  const ClassDetailPage({Key? key, required this.classData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${classData.className}', style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mã lớp: ${classData.classId}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tên lớp: ${classData.className}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Loại lớp: ${classData.classType}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Số lượng tối đa: ${classData.maxStudents}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Thời gian bắt đầu: ${classData.startDate}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Thời gian kết thúc: ${classData.endDate}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
