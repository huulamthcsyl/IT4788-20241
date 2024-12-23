import 'package:flutter/material.dart';
import 'package:it4788_20241/class_assignment/widgets/submission_detail.dart';

class ResponseItem extends StatelessWidget {
  final String name;
  final String email;
  final String submissionTime;
  final double? grade;
  final String textResponse;
  final String? fileUrl;
  final String accountId;
  final ValueChanged<double?> onGradeChange;
  final Future<void> Function(String) onSubmit; // Thay đổi thành Future<void>

  const ResponseItem({
    super.key,
    required this.name,
    required this.email,
    required this.submissionTime,
    required this.grade,
    required this.textResponse,
    required this.fileUrl,
    required this.accountId,
    required this.onGradeChange,
    required this.onSubmit, // Thay đổi thành Future<void>
  });

  String formatDate(String date) {
    try {
      DateTime dateTime = DateTime.parse(date);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return SubmissionDetailPopup(
              name: name,
              textResponse: textResponse,
              fileUrl: fileUrl,
              grade: grade,
              onGradeChange: (double newGrade) {
                onGradeChange(newGrade);
              },
              onSubmit: () async {
                await onSubmit(accountId); // Await onSubmit
              },
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: double.infinity, // Take up full width
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              email,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Nộp bài vào: ${formatDate(submissionTime)}',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              grade == null ? 'Không có điểm' : '$grade điểm',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}