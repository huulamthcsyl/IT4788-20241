import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ClassMaterialUploadFilePage extends StatefulWidget {
  @override
  _ClassMaterialUploadFileState createState() => _ClassMaterialUploadFileState();
}

class _ClassMaterialUploadFileState extends State<ClassMaterialUploadFilePage> {
  File? selectedFile;
  bool isUploading = false;
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload tài liệu cho lớp: 154028'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.attach_file),
              label: Text('Chọn file'),
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles();
                if (result == null) return;
                setState(() {
                  selectedFile = File(result.files.single.path!);
                });
              },
            ),
            if (selectedFile != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedFile!.path.split('/').last,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  // Nút upload file
                  ElevatedButton(
                    onPressed: null , //
                    child: Text('Upload'),
                  ),
                ],
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}