import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/class_material/models/class_material_model.dart';
import 'package:provider/provider.dart';

import '../viewmodels/class_material_viewmodels.dart';

class ClassMaterialEditPage extends StatefulWidget
{
  final ClassMaterial classMaterial;
  ClassMaterialEditPage({required this.classMaterial});
  @override
  _ClassMaterialEditState createState() => _ClassMaterialEditState();
}

class _ClassMaterialEditState extends State<ClassMaterialEditPage> {
  late ClassMaterial classMaterial;

  @override
  void initState() {
    super.initState();
    classMaterial = widget.classMaterial;
    final viewModel = Provider.of<ClassMaterialViewModel>(context, listen: false);
    viewModel.old_material_id = classMaterial.ID.toString();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController materialTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassMaterialViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa tài liệu: ${classMaterial.ID}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title [${classMaterial.material_name}]',
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

                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description [${classMaterial.description}]',
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
                controller: materialTypeController,
                  decoration: InputDecoration(
                    labelText: 'Type [${classMaterial.material_type}]',
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
                  ),      )
              ,
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.attach_file,color: Colors.black),
                label: Text('Chọn file', style: TextStyle(color: Colors.black)),
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
                      viewModel.editFile();
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
                      : Text('Lưu thay đổi'),
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
