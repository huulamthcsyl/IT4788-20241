import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/classCtrl/viewmodels/classCtrl_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:it4788_20241/classCtrl/views/classCtrlForm_view.dart'; // Import form để thêm và chỉnh sửa lớp

class ClassCtrlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ClassCtrlViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý lớp')),
      body: ListView.builder(
        itemCount: viewModel.classes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(viewModel.classes[index].name),
            subtitle: Text('Số lượng sinh viên: ${viewModel.classes[index].studentCount}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Điều hướng đến form sửa lớp
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassCtrlFormPage(
                          classData: viewModel.classes[index],
                          onSave: (classData) => viewModel.editClass(index, classData),
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    viewModel.deleteClass(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text('Lớp đã bị xóa')),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClassCtrlFormPage(
                onSave: viewModel.addClass,
              ),
            ),
          );
        },
      ),
    );
  }
}