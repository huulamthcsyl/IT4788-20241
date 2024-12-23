import 'package:flutter/material.dart';
import 'package:it4788_20241/class/views/class_student_view.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/classCtrl/views/class_detail_page.dart';
import 'package:it4788_20241/class_assignment/models/submission_data.dart';
import 'package:provider/provider.dart';
import 'package:it4788_20241/class_assignment/widgets/assignment_item.dart';
import 'package:it4788_20241/class_assignment/views/assignment_detail_view.dart';
import 'package:it4788_20241/class_assignment/viewmodels/assignment_list_viewmodel.dart';
import 'package:it4788_20241/class_assignment/models/assignment_data.dart';
import 'package:it4788_20241/class_assignment/widgets/create_assignment_dialog.dart';
import 'package:it4788_20241/class_assignment/widgets/confirm_delete_dialog.dart';

class AssignmentListView extends StatefulWidget {
  final ClassData classData;

  const AssignmentListView({super.key, required this.classData});

  @override
  AssignmentListViewState createState() => AssignmentListViewState();
}

class AssignmentListViewState extends State<AssignmentListView> {
  late String classCode, className;

  @override
  void initState() {
    super.initState();
    classCode = widget.classData.classId;
    className = widget.classData.className;
    final viewModel =
        Provider.of<AssignmentListViewModel>(context, listen: false);
    viewModel.classData = widget.classData;
  }

  Future<void> _refreshData() async {
    final viewModel =
        Provider.of<AssignmentListViewModel>(context, listen: false);
    await viewModel.initialize(); // Re-fetch data
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                final viewModel = Provider.of<AssignmentListViewModel>(context,
                    listen: false);
                if (viewModel.userData.role == "LECTURER") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ClassDetailPage(classData: widget.classData),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClassStudentPage(),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: Text(
              className,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
              onTap: (int index) {
                final viewModel = Provider.of<AssignmentListViewModel>(context,
                    listen: false);
                viewModel.onClickTabBar(index, context);
              },
              indicatorColor: Colors.red,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
              unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal, color: Colors.white),
              tabs: const [
                Tab(text: "Kiểm tra"),
                Tab(text: "Tài liệu"),
                Tab(text: "Khác")
              ],
            ),
            backgroundColor: Colors.red),
        body: FutureBuilder(
          future: Provider.of<AssignmentListViewModel>(context, listen: false)
              .initialize(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Consumer<AssignmentListViewModel>(
                builder: (context, viewModel, child) {
                  return Column(
                    children: [
                      // Button to show the popup view for creating a new assignment
                      if (viewModel.userData.role == "LECTURER")
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (context) => CreateAssignmentDialog(
                                  classData: widget.classData,
                                ),
                              );
                              if (result == true) {
                                _refreshData(); // Reload data if the result is true
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              // Background color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              // Button size
                              textStyle: const TextStyle(fontSize: 18.0),
                              // Font size
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8.0), // Border radius
                              ),
                            ),
                            child: const Text(
                              'Tạo bài tập mới',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      // Extracted search field
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius:
                                BorderRadius.circular(20.0), // Border radius
                          ),
                          child: TextField(
                            onChanged: (value) {
                              context
                                  .read<AssignmentListViewModel>()
                                  .updateSearchQuery(value);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Tìm kiếm theo tên bài tập',
                              filled: true,
                              fillColor: Colors.white,
                              // Background color inside the TextField
                              border: InputBorder.none,
                              // Remove the outline
                              enabledBorder: InputBorder.none,
                              // Remove the outline when enabled
                              focusedBorder: InputBorder.none,
                              // Remove the outline when focused
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.black),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16.0), // Center vertically
                            ),
                            style: const TextStyle(color: Colors.black),
                            textInputAction: TextInputAction.search,
                          ),
                        ),
                      ),
                      // Conditionally show status buttons
                      if (viewModel.userData.role != "LECTURER")
                        _buildStatusButtons(context),
                      // Extracted assignment list view builder
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          child: RefreshIndicator(
                            onRefresh: _refreshData,
                            child: _buildAssignmentListView(context),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatusButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatusButton(context, 'UPCOMING'),
          _buildStatusButton(context, 'PASS_DUE'),
          _buildStatusButton(context, 'COMPLETED'),
        ],
      ),
    );
  }

  Widget _buildStatusButton(BuildContext context, String status) {
    return Consumer<AssignmentListViewModel>(
      builder: (context, viewModel, child) {
        return ElevatedButton(
          onPressed: () {
            viewModel.updateSelectedStatus(status);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: viewModel.selectedStatus == status
                ? const Color(0xFF5D13E7).withOpacity(0.8)
                : const Color(0xFFEEEEEE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Text(
            status == 'UPCOMING'
                ? 'Sắp tới'
                : (status == 'PASS_DUE' ? 'Quá hạn' : 'Đã hoàn thành'),
            style: TextStyle(
              fontSize: 14,
              color: viewModel.selectedStatus == status
                  ? Colors.white
                  : Colors.black,
              fontWeight: viewModel.selectedStatus == status
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAssignmentListView(BuildContext context) {
    return Consumer<AssignmentListViewModel>(
      builder: (context, viewModel, child) {
        List<AssignmentAndSubmission> items = viewModel.filteredData;
        if (items.isEmpty) {
          return const Center(child: Text("Không có bài tập nào."));
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            AssignmentData assignment = items[index].assignment;
            SubmissionData submission = items[index].submission;
            int? turnInCount = items[index].turnInCount;
            int? gradeCount = items[index].gradeCount;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AssignmentItem(
                  title: assignment.title,
                  deadline: assignment.deadline.toString(),
                  status: viewModel.selectedStatus,
                  isSubmitted: assignment.isSubmitted,
                  submissionTime: submission.submissionTime,
                  grade: submission.grade,
                  role: viewModel.userData.role,
                  turnInCount: turnInCount,
                  gradeCount: gradeCount,
                  studentCount: viewModel.classData.studentAccounts.length,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssignmentDetailView(
                          assignment: assignment,
                          submission: submission,
                          classData: widget.classData,
                          status: viewModel.selectedStatus,
                          role: viewModel.userData.role,
                          refreshListData:
                              _refreshData, // Truyền hàm refreshData
                        ),
                      ),
                    );
                  },
                  onEdit: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) => CreateAssignmentDialog(
                        classData: widget.classData,
                        assignmentData: assignment,
                      ),
                    );
                    if (result == true) {
                      _refreshData(); // Reload data if the result is true
                    }
                  },
                  onDelete: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) => ConfirmDeleteDialog(
                        onConfirm: () async {
                          await viewModel.deleteAssignment(assignment.id);
                          Navigator.of(context)
                              .pop(true); // Pass true to indicate success
                        },
                      ),
                    );
                    if (result == true) {
                      _refreshData(); // Reload data if the result is true
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
