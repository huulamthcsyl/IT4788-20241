import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/classCtrl/viewmodels/classCtrl_viewmodel.dart';
import 'package:it4788_20241/classCtrl/views/classCtrlForm_view.dart';
import 'package:it4788_20241/classCtrl/widget/editClass.dart'; // Import trang sửa lớp
import 'package:it4788_20241/classCtrl/views/class_detail_page.dart'; // Import trang chi tiết lớp
import 'package:it4788_20241/home/views/home_view.dart';
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
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            icon: Icon(Icons.arrow_back, color: Colors.black,),
          ),
        title: const Center(
          child: Text(
            'DANH SÁCH LỚP',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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
      itemCount: viewModel.classes.length + 1,
      itemBuilder: (context, index) {
        if (index == viewModel.classes.length) {
          return _buildLoadMoreButton(viewModel);
        }

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

  Widget _buildLoadMoreButton(ClassCtrlViewModel viewModel) {
    if (!viewModel.hasMore) {
      return const SizedBox.shrink(); // Không còn lớp để tải
    }

    if (viewModel.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          await viewModel.loadMoreClasses(); // Tải thêm lớp
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        child: const Text('Tải thêm'),
      ),
    );
  }

}
