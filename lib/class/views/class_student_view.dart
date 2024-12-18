import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/class_student_viewmodel.dart';

class ClassStudentPage extends StatelessWidget {
  final TextEditingController _classCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassStudentViewModel>(context);

    return ChangeNotifierProvider(
        create: (_) => ClassStudentViewModel()..fetchRegisteredClasses(),
        child: Consumer<ClassStudentViewModel>(
          builder: (context, viewModel, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.red,
                title: Center(
                  child: Text(
                    'Danh sách lớp học',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              body: Column(
                children: [
                  // Phần ảnh logo cố định
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
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
                              // Danh sách lớp đang học
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: viewModel.registeredClasses.length,
                                itemBuilder: (context, index) {
                                  final classItem = viewModel.registeredClasses[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                    child: ListTile(
                                      title: Text("${classItem.class_name} - ${classItem.class_id}"),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Loại lớp: ${classItem.class_type}'),
                                        ],
                                      ),
                                      onTap: () {},
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
                ],
              ),
            );
          },
        ));
  }
}