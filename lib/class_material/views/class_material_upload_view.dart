import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/class_material/viewmodels/class_material_upload_viewmodels.dart';
import 'package:provider/provider.dart';

class ClassMaterialUploadFilePage extends StatefulWidget
{
  @override
  _ClassMaterialUploadFileState createState() => _ClassMaterialUploadFileState();
}

class _ClassMaterialUploadFileState extends State<ClassMaterialUploadFilePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController materialTypeController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassMaterialUploadViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload tài liệu cho lớp: 000089'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: materialTypeController,
                decoration: InputDecoration(labelText: 'Material Type'),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.attach_file),
                label: Text('Chọn file'),
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles();
                  if (result == null) return;
                  setState(() {
                    viewModel.title = titleController.text;
                    viewModel.description = descriptionController.text;
                    viewModel.materialType = materialTypeController.text;
                    viewModel.filePath = result.files.single.path!;
                  });
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
                          setState(() {
                            viewModel.filePath = "";
                          });
                        },
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: ()
                  {
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
              if (viewModel.isUploading) Padding(
                padding: EdgeInsets.only(top: 20)
              ),
            ],
          ),
        ),
      ),
    );
  }

}
