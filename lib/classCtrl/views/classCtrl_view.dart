import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/classCtrl/viewmodels/classCtrl_viewmodel.dart';
import 'package:it4788_20241/classCtrl/views/classCtrlForm_view.dart';
import 'package:it4788_20241/classCtrl/widget/editClass.dart'; // Import trang sửa lớp
import 'package:it4788_20241/classCtrl/views/class_detail_page.dart'; // Import trang chi tiết lớp
import 'package:provider/provider.dart';

class ClassCtrlPage extends StatefulWidget {
  @override
  _ClassCtrlPageState createState() => _ClassCtrlPageState();
}

class _ClassCtrlPageState extends State<ClassCtrlPage> {

  @override
  void initState() {
    super.initState();
    _fetchData(); // Gọi hàm để làm mới dữ liệu khi trang khởi tạo.
  }

  // Hàm để khởi động lại dữ liệu
  void _fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassCtrlViewModel>().fetchClasses(); // Làm mới danh sách lớp
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ClassCtrlViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            icon: Icon(Icons.arrow_back, color: Colors.white,),
          ),
        title: Text(
        'DANH SÁCH LỚP',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ), centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildBody(viewModel),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget _buildBody(ClassCtrlViewModel viewModel) {
    if (viewModel.isLoading && viewModel.classes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Text(
          viewModel.errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (viewModel.classes.isEmpty) {
      return const Center(child: Text('Không có lớp học nào.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: viewModel.classes.length,
      itemBuilder: (context, index) {
        final classData = viewModel.classes[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(7.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            title: Text(classData.className),
            subtitle: Text('Mã lớp: ${classData.classId}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassDetailPage(classData: classData),
                ),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditClassWidget(
                          classData: classData,
                          onSave: (updatedClass) {
                            viewModel.editClass(index, updatedClass);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Lớp học đã được cập nhật thành công!')),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    viewModel.showDeleteConfirmationDialog(context, classData.classId, viewModel);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
