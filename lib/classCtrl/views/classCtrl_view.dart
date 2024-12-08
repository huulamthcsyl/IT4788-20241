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
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassCtrlViewModel>().fetchClasses(); // Lấy danh sách lớp khi trang được hiển thị
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ClassCtrlViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Center(
          child: Text(
            'DANH SÁCH LỚP',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassCtrlFormPage(
                    onSave: (newClass) {
                      context.read<ClassCtrlViewModel>().addClass(newClass);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildBody(viewModel),
          ),
          const SizedBox(height: 10.0),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/class-list'),
            child: const Text(
              'Thông tin danh sách các lớp',
              style: TextStyle(
                color: Colors.red,
                fontStyle: FontStyle.italic,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget _buildBody(ClassCtrlViewModel viewModel) {
    if (viewModel.isLoading) {
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
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            title: Text(classData.className),
            subtitle: Text('Mã lớp: ${classData.classId}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassDetailPage(classData: classData), // Chi tiết lớp
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
                            viewModel.editClass(index, updatedClass); // Sửa lớp
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
                    _showDeleteConfirmationDialog(context, classData.classId, viewModel);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show a confirmation dialog before deleting the class
  void _showDeleteConfirmationDialog(BuildContext context, String classId, ClassCtrlViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa lớp'),
          content: const Text('Bạn có chắc chắn muốn xóa lớp này?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                // Call the deleteClass method from ViewModel
                await viewModel.deleteClass(classId);

                if (viewModel.errorMessage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lớp học đã được xóa thành công!')),
                  );
                  // Refresh the class list after deletion
                  context.read<ClassCtrlViewModel>().fetchClasses();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(viewModel.errorMessage!)),
                  );
                }
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}
