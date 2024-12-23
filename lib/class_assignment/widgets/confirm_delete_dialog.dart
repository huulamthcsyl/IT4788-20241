import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmDeleteDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Xác nhận xóa'),
      content: const Text('Bạn có chắc chắn muốn xóa bài tập này không?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.greenAccent.withOpacity(0.8), // Background color for "Hủy" button
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Hủy',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent.withOpacity(0.8), // Background color for "Tạo" button
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Xóa',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
          ),        ),
      ],
    );
  }
}