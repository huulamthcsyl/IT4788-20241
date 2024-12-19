import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/profile_viewmodel.dart';

class ChangeAvatarDialog extends StatefulWidget {
  File selectedImage;
  ChangeAvatarDialog({required this.selectedImage});
  @override
  _ChangeAvatarDialogState createState() => _ChangeAvatarDialogState();
}

class _ChangeAvatarDialogState extends State<ChangeAvatarDialog> {
  @override
  Widget build(BuildContext context) {
    final _profileViewModel =
    Provider.of<ProfileViewModel>(context, listen: false);
    return AlertDialog(
      title: Text("Đổi ảnh đại diện"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Kiểm tra _selectedImage để hiển thị ảnh hoặc placeholder
          widget.selectedImage != null && widget.selectedImage.path.isNotEmpty
              ? Image.file(
            File(widget.selectedImage.path),
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          )
              : Container(
            height: 150,
            width: 150,
            color: Colors.grey[200],
            child: Icon(Icons.image, size: 50, color: Colors.grey),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              await _profileViewModel.pickImageFromGallery();
              if (_profileViewModel.filePicked != null) {
                setState(() {
                  widget.selectedImage = File(_profileViewModel.filePicked.path);
                });
              }
            },
            icon: Icon(Icons.photo_library),
            label: Text("Chọn ảnh"),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.redAccent,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Hủy',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(width: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.green,
          ),
          onPressed: () {
            if (widget.selectedImage != null &&
                widget.selectedImage.path.isNotEmpty) {
              _profileViewModel.changeAvatar(context, widget.selectedImage);
            }
          },
          child: Text(
            'Lưu',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }
}