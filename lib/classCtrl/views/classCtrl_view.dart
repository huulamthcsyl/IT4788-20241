import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/viewmodels/classCtrl_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:it4788_20241/classCtrl/views/classCtrlForm_view.dart'; // Import form để thêm và chỉnh sửa lớp

class ClassCtrlPage extends StatefulWidget {
  @override
  _ClassCtrlPageState createState() => _ClassCtrlPageState();
}

class _ClassCtrlPageState extends State<ClassCtrlPage> {
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ClassCtrlViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Mũi tên quay lại
          onPressed: () {
            Navigator.pop(context); // Quay trở lại trang trước
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
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Hiển thị thanh tìm kiếm nếu _isSearching == true
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm lớp...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          // Danh sách lớp
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: viewModel.searchClasses(_searchQuery).length,
                itemBuilder: (context, index) {
                  final classData = viewModel.searchClasses(_searchQuery)[index];
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
                      // Hiển thị mã lớp và mã lớp kèm
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mã lớp: ${classData.classId}'),
                          Text('Mã lớp kèm: ${classData.classCode}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClassCtrlFormPage(
                                    classData: classData,
                                    onSave: (updatedClass) => viewModel.editClass(index, updatedClass),
                                  ),
                                ),
                              );
                            },
                          ),
                          // IconButton(
                          //   icon: const Icon(Icons.delete, color: Colors.red),
                          //   onPressed: () {
                          //     showDialog(
                          //       context: context,
                          //       builder: (context) {
                          //         return AlertDialog(
                          //           title: const Text('Xác nhận xóa'),
                          //           content: const Text('Bạn có chắc chắn muốn xóa lớp này?'),
                          //           actions: [
                          //             TextButton(
                          //               onPressed: () {
                          //                 Navigator.of(context).pop();
                          //               },
                          //               child: const Text('Hủy'),
                          //             ),
                          //             TextButton(
                          //               onPressed: () {
                          //                 viewModel.deleteClass(index);
                          //                 ScaffoldMessenger.of(context).showSnackBar(
                          //                   SnackBar(content: const Text('Lớp đã bị xóa')),
                          //                 );
                          //                 Navigator.of(context).pop();
                          //               },
                          //               child: const Text('Xóa'),
                          //             ),
                          //           ],
                          //         );
                          //       },
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Dòng chữ "Thông tin danh sách các lớp mở"
          SizedBox(height: 10.0), // Khoảng cách giữa danh sách và dòng chữ
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/class-list');  // Sử dụng route name để điều hướng
            },
            child: Text(
              'Thông tin danh sách các lớp mở',
              style: TextStyle(
                color: Colors.red, // Màu đỏ
                fontStyle: FontStyle.italic, // In nghiêng
                decoration: TextDecoration.underline, // Gạch chân
              ),
            ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 26.0, bottom: 26.0),
        child: FloatingActionButton(
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
      ),
    );
  }
}