import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/class_material/viewmodels/class_material_viewmodels.dart';
import 'package:provider/provider.dart';

class ClassMaterialUploadFilePage extends StatefulWidget {
  @override
  _ClassMaterialUploadFileState createState() => _ClassMaterialUploadFileState();
}

class _ClassMaterialUploadFileState extends State<ClassMaterialUploadFilePage> {
  @override
  void dispose() {
    final viewModel = Provider.of<ClassMaterialViewModel>(context, listen: false);
    viewModel.clearControllers();
    viewModel.resetUploadFields();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassMaterialViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload tài liệu cho lớp: ${viewModel.classData.className}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: viewModel.titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                  controller: viewModel.descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                  )),
              SizedBox(height: 10),
              TextField(
                controller: viewModel.materialTypeController,
                decoration: InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.attach_file, color: Colors.black,),
                label: Text('Chọn file', style: TextStyle(color: Colors.black),),
                onPressed: () {
                  viewModel.pickFile();
                },
              ),
              if (viewModel.filePath.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          viewModel.filePath.split('/').last,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          viewModel.clearPickedFile();
                        },
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    viewModel.uploadFile();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    elevation: 5,
                  ),
                  child: viewModel.isUploading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Upload'),
                ),
              ),
              if (viewModel.isUploading)
                Padding(padding: EdgeInsets.only(top: 20)),
            ],
          ),
        ),
      ),
    );
  }
}