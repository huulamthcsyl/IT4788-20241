import 'package:flutter/material.dart';
import 'package:it4788_20241/auth/models/class_data.dart'; // Đảm bảo import mô hình dữ liệu lớp

class ClassCtrlViewModel extends StatefulWidget {
  final ClassData? classData;
  final Function(ClassData) onSave;

  ClassCtrlViewModel({this.classData, required this.onSave});

  @override
  _ClassCtrlViewModelState createState() => _ClassCtrlViewModelState();
}

class _ClassCtrlViewModelState extends State<ClassCtrlViewModel> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late int studentCount;

  @override
  void initState() {
    super.initState();
    if (widget.classData != null) {
      name = widget.classData!.name;
      studentCount = widget.classData!.studentCount;
    } else {
      name = '';
      studentCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.classData == null ? 'Thêm lớp mới' : 'Sửa lớp')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Tên lớp'),
                onSaved: (value) => name = value ?? '',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Vui lòng nhập tên lớp';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: studentCount.toString(),
                decoration: InputDecoration(labelText: 'Số lượng sinh viên'),
                keyboardType: TextInputType.number,
                onSaved: (value) => studentCount = int.tryParse(value ?? '0') ?? 0,
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
                    _formKey.currentState!.save();
                    widget.onSave(ClassData(name, studentCount));
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