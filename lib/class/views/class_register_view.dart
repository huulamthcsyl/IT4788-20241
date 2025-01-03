import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/class_register_viewmodel.dart';
import '../widgets/class_detail_dialog.dart';

class RegisterClassPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassRegisterViewModel>(context);

    return ChangeNotifierProvider(
        create: (_) => ClassRegisterViewModel()..fetchRegisteredClasses(),
        child: Consumer<ClassRegisterViewModel>(
          builder: (context, viewModel, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white)),
                automaticallyImplyLeading: false,
                backgroundColor: Colors.red,
                title: const Text(
                  'ĐĂNG KÝ LỚP HỌC',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: TextField(
                              controller: viewModel.classCodeController,
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
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10.0),
                                hintStyle: TextStyle(
                                    color: Colors.red, fontSize: 20.0),
                              ),
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            final classId = viewModel.classCodeController.text.trim();
                            if (classId.isNotEmpty) {
                              viewModel.addNewClass(classId);
                            }

                            viewModel.classCodeController.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                          ),
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Phần scrollable (danh sách lớp)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Kiểm tra danh sách lớp đã đăng ký và lớp mới
                          (viewModel.registeredClasses.isEmpty &&
                              viewModel.newClasses.isEmpty)
                              ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Bạn chưa đăng ký lớp học nào',
                              style: TextStyle(
                                  color: Colors.red, fontSize: 18.0),
                            ),
                          )
                              : Column(
                            children: [
                              // Danh sách lớp đã đăng ký
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                viewModel.registeredClasses.length,
                                itemBuilder: (context, index) {
                                  final classItem =
                                  viewModel.registeredClasses[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    child: ListTile(
                                      title: Text(classItem.class_name),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Mã lớp: ${classItem.class_id}'),
                                          Text(
                                              'Loại lớp: ${classItem.class_type}'),
                                        ],
                                      ),
                                      trailing: TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => ClassDetailsDialog(classInfo: classItem),
                                          );
                                        },
                                        child: Text('Chi tiết', style: TextStyle(color: Colors.red)),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Danh sách lớp mới
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: viewModel.newClasses.length,
                                itemBuilder: (context, index) {
                                  final classItem =
                                  viewModel.newClasses[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    child: ListTile(
                                      title: Text(classItem.class_name),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Mã lớp: ${classItem.class_id}'),
                                          Text(
                                              'Loại lớp: ${classItem.class_type}'),
                                        ],
                                      ),
                                      trailing: TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => ClassDetailsDialog(classInfo: classItem),
                                          );
                                        },
                                        child: Text('Chi tiết', style: TextStyle(color: Colors.red)),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Nút gửi đăng ký
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: SizedBox(
                      width: double.infinity, // Chiếm toàn bộ chiều rộng
                      child: ElevatedButton(
                        onPressed: () async {
                          await viewModel.submitRegistration();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ),
                        child: Text('Gửi đăng ký',
                            style:
                            TextStyle(color: Colors.white, fontSize: 20.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            );
          },
        ));
  }
}