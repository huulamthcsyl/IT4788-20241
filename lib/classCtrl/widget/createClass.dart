import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Thư viện định dạng ngày tháng
import 'package:it4788_20241/classCtrl/viewmodels/classCtrlForm_viewmodel.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart'; // Import model ClassData
import 'package:it4788_20241/auth/models/user_data.dart'; // Import model UserData

class CreateClassWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function(ClassData) onSave;

  CreateClassWidget({required this.formKey, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassCtrlFormViewModel>(context);
    const List<String> classTypes = ['LT', 'BT', 'LT_BT'];

    // Controllers để xử lý việc nhập ngày bằng tay
    final TextEditingController startDateController = TextEditingController();
    final TextEditingController endDateController = TextEditingController();

    // Nếu có giá trị ngày bắt đầu và ngày kết thúc, set vào controller
    if (viewModel.startDate.isNotEmpty) {
      startDateController.text = viewModel.startDate;
    }
    if (viewModel.endDate.isNotEmpty) {
      endDateController.text = viewModel.endDate;
    }

    // Hàm chọn ngày từ lịch
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

        // Cập nhật viewModel
        if (isStartDate) {
          viewModel.startDate = formattedDate;
        } else {
          viewModel.endDate = formattedDate;
        }
      }
    }

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mã lớp
          TextFormField(
            initialValue: viewModel.classId,
            decoration: const InputDecoration(labelText: 'Mã lớp'),
            onChanged: (value) => viewModel.classId = value,
            validator: (value) => value!.isEmpty ? 'Vui lòng nhập mã lớp' : null,
          ),
          // Mã lớp kèm
          TextFormField(
            initialValue: viewModel.classCode,
            decoration: const InputDecoration(labelText: 'Mã lớp kèm'),
            onChanged: (value) => viewModel.classCode = value,
          ),
          // Tên lớp
          TextFormField(
            initialValue: viewModel.name,
            decoration: const InputDecoration(labelText: 'Tên lớp'),
            onChanged: (value) => viewModel.name = value,
            validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên lớp' : null,
          ),
          // Ngày bắt đầu
          TextFormField(
            controller: startDateController,
            decoration: const InputDecoration(labelText: 'Ngày bắt đầu'),
            onTap: () => _selectDate(context, startDateController, true),
            validator: (value) => value!.isEmpty ? 'Vui lòng chọn ngày bắt đầu' : null,
            readOnly: true,  // Không cho phép nhập trực tiếp, chỉ chọn từ lịch
          ),
          // Ngày kết thúc
          TextFormField(
            controller: endDateController,
            decoration: const InputDecoration(labelText: 'Ngày kết thúc'),
            onTap: () => _selectDate(context, endDateController, false),
            validator: (value) => value!.isEmpty ? 'Vui lòng chọn ngày kết thúc' : null,
            readOnly: true,  // Không cho phép nhập trực tiếp, chỉ chọn từ lịch
          ),
          // Loại lớp
          DropdownButtonFormField<String>(
            value: classTypes.contains(viewModel.classType) ? viewModel.classType : null,
            decoration: const InputDecoration(labelText: 'Loại lớp'),
            items: classTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) => viewModel.classType = value ?? '',
            validator: (value) =>
            value == null || value.isEmpty ? 'Vui lòng chọn loại lớp' : null,
          ),
          // Số học sinh tối đa
          TextFormField(
            initialValue: viewModel.maxStudents.toString(),
            decoration: const InputDecoration(labelText: 'Số học sinh tối đa'),
            keyboardType: TextInputType.number,
            onChanged: (value) => viewModel.maxStudents = int.tryParse(value) ?? 0,
            validator: (value) =>
            value!.isEmpty ? 'Vui lòng nhập số học sinh tối đa' : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final classData = viewModel.saveClass();
                classData.status = 'ACTIVE'; // Trạng thái lớp mặc định là 'ACTIVE'
                classData.studentAccounts = []; // Giả sử không có sinh viên khi tạo mới lớp

                // Gọi phương thức createClass từ ViewModel để gọi API
                await viewModel.createClass(classData);

                // Sau khi gọi API thành công, bạn có thể thực hiện các hành động như
                // hiển thị thông báo thành công, hoặc quay lại trang trước.
                onSave(classData);  // Gọi lại hàm onSave nếu cần

                Navigator.pop(context);  // Quay lại màn hình trước sau khi lưu
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}