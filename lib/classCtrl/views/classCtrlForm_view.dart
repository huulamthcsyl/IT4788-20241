import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart'; // Đảm bảo import mô hình dữ liệu lớp
import 'package:provider/provider.dart';
import 'package:it4788_20241/classCtrl/viewmodels/classCtrlForm_viewmodel.dart'; // Import ViewModel

class ClassCtrlFormPage extends StatefulWidget {
  final ClassData? classData;
  final Function(ClassData) onSave;

  ClassCtrlFormPage({this.classData, required this.onSave});

  @override
  _ClassCtrlFormViewsState createState() => _ClassCtrlFormViewsState();
}

class _ClassCtrlFormViewsState extends State<ClassCtrlFormPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<ClassCtrlFormViewModel>(context, listen: false);
    if (widget.classData != null) {
      viewModel.name = widget.classData!.name;
      viewModel.studentCount = widget.classData!.studentCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassCtrlFormViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.classData == null ? 'Thêm lớp mới' : 'Sửa lớp')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: viewModel.name,
                decoration: InputDecoration(labelText: 'Tên lớp'),
                onChanged: (value) => viewModel.name = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Vui lòng nhập tên lớp';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: viewModel.studentCount.toString(),
                decoration: InputDecoration(labelText: 'Số lượng sinh viên'),
                keyboardType: TextInputType.number,
                onChanged: (value) => viewModel.studentCount = int.tryParse(value) ?? 0,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Vui lòng nhập số lượng sinh viên';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newClass = viewModel.saveClass();
                    widget.onSave(newClass);
                    Navigator.pop(context);
                  }
                },
                child: Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}