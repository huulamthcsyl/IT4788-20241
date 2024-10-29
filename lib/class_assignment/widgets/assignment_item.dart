import 'package:flutter/material.dart';

class AssignmentItem extends StatelessWidget {
  final String avatarUrl;
  final String assignmentName;
  final String submissionTime;
  final String className;
  final String status;
  final VoidCallback onTap;

  const AssignmentItem({
    super.key,
    required this.avatarUrl,
    required this.assignmentName,
    required this.submissionTime,
    required this.className,
    required this.status,
    required this.onTap,
  });

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    IconData getStatusIcon() {
      switch (status) {
        case 'Upcoming':
          return Icons.schedule;
        case 'Past due':
          return Icons.error;
        case 'Completed':
          return Icons.check;
        default:
          return Icons.help;
      }
    }

    Color getStatusColor() {
      switch (status) {
        case 'Upcoming':
          return Colors.blue;
        case 'Past due':
          return Colors.red;
        case 'Completed':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    String getSubmissionText() {
      switch (status) {
        case 'Upcoming':
        case 'Past due':
          return 'Due at ${formatDate(submissionTime)}';
        case 'Completed':
          return 'Submitted at ${formatDate(submissionTime)}';
        default:
          return formatDate(submissionTime);
      }
    }

    Color getSubmissionTextColor() {
      switch (status) {
        case 'Upcoming':
        case 'Past due':
          return Colors.red;
        case 'Completed':
          return Colors.black54;
        default:
          return Colors.black54;
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
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: getStatusColor(),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  className.substring(0, 2).toUpperCase(),
                  style: const TextStyle(fontSize: 24.0, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignmentName,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    getSubmissionText(),
                    style: TextStyle(
                        fontSize: 14.0, color: getSubmissionTextColor()),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    className,
                    style: const TextStyle(fontSize: 14.0, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: getStatusColor(),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Icon(
                getStatusIcon(),
                color: Colors.white,
                size: 24.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}