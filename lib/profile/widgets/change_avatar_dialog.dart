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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Đổi ảnh đại diện",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: widget.selectedImage != null &&
                  widget.selectedImage.path.isNotEmpty
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
                child:
                Icon(Icons.image, size: 50, color: Colors.grey[400]),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () async {
                await _profileViewModel.pickImageFromGallery();
                if (_profileViewModel.filePicked != null) {
                  setState(() {
                    widget.selectedImage =
                        File(_profileViewModel.filePicked.path);
                  });
                }
              },
              icon: Icon(Icons.photo_library, color: Colors.white),
              label: Text(
                "Chọn ảnh",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Hủy',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    if (widget.selectedImage != null &&
                        widget.selectedImage.path.isNotEmpty) {
                      _profileViewModel.changeAvatar(
                          context, widget.selectedImage);
                    }
                  },
                  child: Text(
                    'Lưu',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}