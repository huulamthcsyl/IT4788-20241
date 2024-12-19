import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:it4788_20241/classCtrl/viewmodels/classCtrlForm_viewmodel.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/classCtrl/widget/createClass.dart';
import 'package:it4788_20241/classCtrl/widget/editClass.dart';

class ClassCtrlFormPage extends StatefulWidget {
  final Function(ClassData) onSave;

  ClassCtrlFormPage({required this.onSave});

  @override
  _ClassCtrlFormPageState createState() => _ClassCtrlFormPageState();
}

class _ClassCtrlFormPageState extends State<ClassCtrlFormPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'THÊM LỚP MỚI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CreateClassWidget(
          formKey: _formKey,
          onSave: (newClass) {
            widget.onSave(newClass); // Gọi lại hàm onSave để cập nhật lớp
          },
        ),
      ),
    );
  }
}
