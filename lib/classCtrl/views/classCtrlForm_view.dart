import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:provider/provider.dart';
import 'package:it4788_20241/classCtrl/viewmodels/classCtrlForm_viewmodel.dart';

class ClassCtrlFormPage extends StatefulWidget {
  final ClassData? classData;
  final Function(ClassData) onSave;
  final int? classIndex;

  ClassCtrlFormPage({this.classData, required this.onSave, this.classIndex});

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
      viewModel.classId = widget.classData!.classId;
      viewModel.classCode = widget.classData!.classCode;
      viewModel.name = widget.classData!.className;
      viewModel.maxStudents = widget.classData!.maxStudents;
      viewModel.courseCode = widget.classData!.courseCode;
      viewModel.classType = widget.classData!.classType;
      viewModel.schedule = widget.classData!.schedule;
      viewModel.classroom = widget.classData!.classroom;
      viewModel.credits = widget.classData!.credits;
      viewModel.status = widget.classData!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassCtrlFormViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'HUST',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.classData == null ? 'Thêm lớp mới' : 'Sửa lớp',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  if (widget.classData != null)
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Xác nhận xóa'),
                              content: const Text('Bạn có chắc chắn muốn xóa lớp này?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    viewModel.deleteClass(widget.classIndex!);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: const Text('Lớp đã bị xóa')),
                                    );
                                    Navigator.of(context).pop();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Xóa'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Xóa lớp', style: TextStyle(color: Colors.red)),
                    ),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: viewModel.classId,
                          decoration: InputDecoration(labelText: 'Mã lớp'),
                          onChanged: (value) {
                            viewModel.classId = value;
                            setState(() {}); // Cập nhật giao diện khi thay đổi
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập mã lớp';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: viewModel.classCode,
                          decoration: InputDecoration(labelText: 'Mã lớp kèm'),
                          onChanged: (value) {
                            viewModel.classCode = value;
                            setState(() {}); // Cập nhật giao diện khi thay đổi
                          },
                        ),
                        TextFormField(
                          initialValue: viewModel.name,
                          decoration: InputDecoration(labelText: 'Tên lớp'),
                          onChanged: (value) {
                            viewModel.name = value;
                            setState(() {}); // Cập nhật giao diện khi thay đổi
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập tên lớp';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: viewModel.courseCode,
                          decoration: InputDecoration(labelText: 'Mã học phần'),
                          onChanged: (value) {
                            viewModel.courseCode = value;
                            setState(() {}); // Cập nhật giao diện khi thay đổi
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập mã học phần';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: viewModel.classType,
                          decoration: InputDecoration(labelText: 'Loại lớp'),
                          onChanged: (value) {
                            viewModel.classType = value;
                            setState(() {}); // Cập nhật giao diện khi thay đổi
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập loại lớp';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: viewModel.schedule,
                          decoration: InputDecoration(labelText: 'Thời gian học'),
                          onChanged: (value) {
                            viewModel.schedule = value;
                            setState(() {}); // Cập nhật giao diện khi thay đổi
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập thời gian học';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: viewModel.classroom,
                          decoration: InputDecoration(labelText: 'Phòng học'),
                          onChanged: (value) {
                            viewModel.classroom = value;
                            setState(() {}); // Cập nhật giao diện khi thay đổi
                          },
                        ),
                        TextFormField(
                          initialValue: viewModel.credits.toString(),
                          decoration: InputDecoration(labelText: 'Số tín chỉ'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            viewModel.credits = int.tryParse(value) ?? 0;
                            setState(() {}); // Cập nhật giao diện khi thay đổi
                          },
                        ),
                        TextFormField(
                          initialValue: viewModel.maxStudents.toString(),
                          decoration: InputDecoration(labelText: 'Số học sinh tối đa'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            viewModel.maxStudents = int.tryParse(value) ?? 0;
                            setState(() {}); // Cập nhật giao diện khi thay đổi
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui lòng nhập số học sinh tối đa';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              widget.onSave(viewModel.saveClass());
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Lưu'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}