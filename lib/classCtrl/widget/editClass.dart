import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/classCtrl/viewmodels/classCtrlForm_viewmodel.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';

import '../viewmodels/classCtrl_viewmodel.dart';

class EditClassWidget extends StatelessWidget {
  final ClassData classData;
  final Function(ClassData) onSave;

  EditClassWidget({required this.classData, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassCtrlViewModel>(context, listen: false);

    // Khởi tạo giá trị
    viewModel.classId = classData.classId;
    viewModel.name = classData.className;
    viewModel.startDate = classData.startDate ?? '';
    viewModel.endDate = classData.endDate ?? '';
    viewModel.classType = classData.classType;
    viewModel.maxStudents = classData.maxStudents;

    final TextEditingController startDateController = TextEditingController(text: viewModel.startDate);
    final TextEditingController endDateController = TextEditingController(text: viewModel.endDate);

    Future<void> _selectDate(BuildContext context, TextEditingController controller, bool isStartDate) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        controller.text = formattedDate;
        if (isStartDate) {
          viewModel.startDate = formattedDate;
        } else {
          viewModel.endDate = formattedDate;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Sửa Lớp', style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: viewModel.name,
                decoration: const InputDecoration(labelText: 'Tên lớp'),
                onChanged: (value) => viewModel.name = value,
              ),
              TextFormField(
                controller: startDateController,
                decoration: const InputDecoration(labelText: 'Ngày bắt đầu'),
                onTap: () => _selectDate(context, startDateController, true),
                readOnly: true,
              ),
              TextFormField(
                controller: endDateController,
                decoration: const InputDecoration(labelText: 'Ngày kết thúc'),
                onTap: () => _selectDate(context, endDateController, false),
                readOnly: true,
              ),
              DropdownButtonFormField<String>(
                value: viewModel.classType,
                decoration: const InputDecoration(labelText: 'Loại lớp'),
                items: ['LT', 'BT', 'LT_BT'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => viewModel.classType = value ?? '',
              ),
              ElevatedButton(
                onPressed: () async {
                  // Cập nhật lớp và gọi API
                  await viewModel.updateClass(viewModel.saveClass());
                  Navigator.pop(context);  // Quay lại trang trước
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}