import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/classCtrl/viewmodels/classCtrl_viewmodel.dart';
import 'package:it4788_20241/classCtrl/views/classCtrl_view.dart';
import 'package:provider/provider.dart';

import '../../chat/views/conversation_view.dart';
import '../../class_material/views/class_material_view.dart';

class ClassDetailPage extends StatefulWidget {
  final ClassData classData;

  const ClassDetailPage({Key? key, required this.classData}) : super(key: key);

  @override
  _ClassDetailPageState createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch the student list for the class when the page loads
      context.read<ClassCtrlViewModel>().getStudentListForClass(widget.classData.classId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassCtrlPage(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          widget.classData.className,
          style: const TextStyle(color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Thông tin lớp
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Mã lớp:', widget.classData.classId),
                      const SizedBox(height: 8),
                      _buildInfoRow('Tên lớp:', widget.classData.className),
                      const SizedBox(height: 8),
                      _buildInfoRow('Loại lớp:', widget.classData.classType),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                          'Số lượng tối đa:', widget.classData.maxStudents.toString()),
                      const SizedBox(height: 8),
                      _buildInfoRow('Thời gian bắt đầu:',
                          widget.classData.startDate ?? "N/A"),
                      const SizedBox(height: 8),
                      _buildInfoRow('Thời gian kết thúc:',
                          widget.classData.endDate ?? "N/A"),
                    ],
                  ),
                ),
              ),

              // Nút chuyển đến các phần
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 2 / 3,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClassMaterialPage(classData: widget.classData),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: Colors.white,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ).copyWith(
                        shadowColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.7)),
                        elevation: MaterialStateProperty.resolveWith<double>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return 4;
                            }
                            return 2;
                          },
                        ),
                      ),
                      child: const Text(
                        'Xem chi tiết lớp',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Danh sách sinh viên
              const Text(
                'Danh sách sinh viên:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Consumer<ClassCtrlViewModel>(
                builder: (context, viewModel, child) {
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

                  final studentList = widget.classData.studentAccounts;

                  if (studentList.isEmpty) {
                    return const Text(
                      'Không có sinh viên trong lớp này.',
                      style: TextStyle(fontSize: 16),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: studentList.length,
                    itemBuilder: (context, index) {
                      final student = studentList[index];
                      return Card(
                        elevation: 3.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            '${student.firstName} ${student.lastName}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'Email: ${student.email ?? "N/A"}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Mã số sinh viên: ${student.studentId ?? "N/A"}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.chat),
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ConversationPage(partnerId: int.parse(student.accountId))
                                  )
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tiện ích để hiển thị thông tin lớp
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}