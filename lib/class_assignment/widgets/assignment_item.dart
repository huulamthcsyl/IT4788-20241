import 'package:flutter/material.dart';

class AssignmentItem extends StatelessWidget {
  final String title;
  final String deadline;
  final String status;
  final bool isSubmitted;
  final String submissionTime;
  final double? grade;
  final String role;
  final int? turnInCount;
  final int? gradeCount;
  final int? studentCount;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AssignmentItem({
    super.key,
    required this.title,
    required this.deadline,
    required this.status,
    required this.isSubmitted,
    required this.submissionTime,
    required this.grade,
    required this.role,
    required this.turnInCount,
    required this.gradeCount,
    required this.studentCount,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
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
    IconData getStatusIcon() {
      switch (status) {
        case 'UPCOMING':
          return Icons.schedule;
        case 'PASS_DUE':
          return Icons.error;
        case 'COMPLETED':
          return Icons.check;
        default:
          return Icons.help;
      }
    }

    Color getStatusColor() {
      switch (status) {
        case 'UPCOMING':
          return Colors.blue.withOpacity(0.8);
        case 'PASS_DUE':
          return Colors.red.withOpacity(0.8);
        case 'COMPLETED':
          return Colors.green.withOpacity(0.8);
        default:
          return Colors.grey;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
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
        child: Row(
          children: [
            if (role == 'STUDENT')
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: getStatusColor(),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Icon(
                    getStatusIcon(),
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    isSubmitted == false
                        ? 'Đến hạn vào ${formatDate(deadline)}'
                        : 'Đã nộp bài vào ${formatDate(submissionTime)}',
                    style:
                        const TextStyle(fontSize: 14.0, color: Colors.black54),
                  ),
                  if (role == 'LECTURER') ...[
                    Text(
                      'Đã nộp: $turnInCount / $studentCount',
                      style: const TextStyle(
                          fontSize: 14.0, color: Colors.black54),
                    ),
                    Text(
                      'Đã trả điểm: $gradeCount / $studentCount',
                      style: const TextStyle(
                          fontSize: 14.0, color: Colors.black54),
                    ),
                  ],

                  if (isSubmitted)
                    Text(
                      grade == null ? 'Không có điểm' : '$grade điểm',
                      style: const TextStyle(
                          fontSize: 14.0, color: Colors.black54),
                    ),
                ],
              ),
            ),
            if (role == 'LECTURER') ...[
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
