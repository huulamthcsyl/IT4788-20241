import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/class_register_viewmodel.dart';

class RegisterClassPage extends StatelessWidget {
  final TextEditingController _classCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassRegisterViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Center(
          child: Text(
            'Đăng ký lớp học',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              color: Colors.red,
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
              child: Center(
                child: Image(
                  image: AssetImage('assets/img/logo_hust_white.png'),
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: _classCodeController,
                        decoration: InputDecoration(
                          labelText: 'Nhập mã lớp học',
                          labelStyle: TextStyle(color: Colors.red),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                          hintStyle: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.addClass(_classCodeController.text);
                      _classCodeController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    ),
                    child: Text('Đăng ký',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            ),
            viewModel.registeredClasses.isEmpty
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Bạn chưa đăng ký lớp học nào',
                style: TextStyle(color: Colors.red, fontSize: 18.0),
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: viewModel.registeredClasses.length,
                itemBuilder: (context, index) {
                  final classItem = viewModel.registeredClasses[index];
                  return Card(
                      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: ListTile(
                        title: Text(classItem.className),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mã lớp: ${classItem.classCode}'),
                            Text('Mã học phần: ${classItem.courseCode}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min, // Chỉ sử dụng không gian cần thiết
                          children: [
                            ElevatedButton(
                              onPressed: () { // Mở modal hoặc trang chi tiết cho lớp học
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('Chi tiết lớp học', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                            SizedBox(height: 16),
                                            Text('Mã lớp: ${classItem.classCode}'),
                                            Text('Mã lớp kèm: ${classItem.linkedClassCode}'),
                                            Text('Mã HP: ${classItem.courseCode}'),
                                            Text('Tên lớp: ${classItem.className}'),
                                            Text('Lịch học: ${classItem.schedule}'),
                                            Text('Phòng học: ${classItem.classroom}'),
                                            Text('Số TC: ${classItem.credits}'),
                                            Text('Loại lớp: ${classItem.classType}'),
                                            Text('Trạng thái: ${classItem.status}'),
                                            SizedBox(height: 16),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Đóng modal
                                              },
                                              child: Text('Đóng', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text('Chi tiết', style: TextStyle(color: Colors.red)),
                            ),
                            SizedBox(width: 8), // Khoảng cách giữa các nút
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                viewModel.deleteClassTemporarily(index);
                              },
                            ),
                          ],
                        ),
                      )
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: viewModel.submitRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    ),
                    child: Text('Gửi đăng ký',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/class-list');
              },
              child: Text(
                'Thông tin danh sách các lớp mở',
                style: TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
