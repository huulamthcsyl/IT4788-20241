import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/class_assignment/models/submission_data.dart';
import 'package:it4788_20241/class_assignment/widgets/response_item.dart';
import 'package:provider/provider.dart';
import 'package:it4788_20241/class_assignment/models/assignment_data.dart';
import 'package:it4788_20241/class_assignment/viewmodels/assignment_detail_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

class AssignmentDetailView extends StatefulWidget {
  final AssignmentData assignment;
  final SubmissionData submission;
  final ClassData classData;
  final String status;
  final String role;
  final VoidCallback refreshListData; // Thêm tham số refreshListData

  const AssignmentDetailView({
    super.key,
    required this.status,
    required this.assignment,
    required this.submission,
    required this.classData,
    required this.role,
    required this.refreshListData, // Thêm tham số refreshListData
  });

  @override
  AssignmentDetailViewState createState() => AssignmentDetailViewState();
}

class AssignmentDetailViewState extends State<AssignmentDetailView> {
  Future<void> _refreshData() async {
    final viewModel =
    Provider.of<AssignmentDetailViewModel>(context, listen: false);
    await viewModel.initialize(); // Re-fetch data
  }

  Future<void> launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AssignmentDetailViewModel(
          widget.assignment, widget.submission, widget.classData),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.classData.className,
                style: const TextStyle(
                    color: Colors.white, fontSize: 20),
              ),
              centerTitle:  true,
              backgroundColor: Colors.red,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  widget.refreshListData(); // Gọi hàm refreshListData khi quay lại
                  Navigator.of(context).pop();
                },
              ),
              actions: <Widget>[
                if (widget.status == 'UPCOMING' &&
                    widget.submission.submissionTime == '' &&
                    widget.role == 'STUDENT')
                  TextButton(
                    onPressed: () {
                      Provider.of<AssignmentDetailViewModel>(context,
                          listen: false)
                          .submitAssignment();
                    },
                    child: const Text(
                      'Nộp bài',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            backgroundColor: Colors.white,
            body: FutureBuilder(
              future:
              Provider.of<AssignmentDetailViewModel>(context, listen: false)
                  .initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Consumer<AssignmentDetailViewModel>(
                    builder: (context, viewModel, child) {
                      return RefreshIndicator(
                        onRefresh: _refreshData,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.role == 'STUDENT')
                                  _buildSubmissionStatus(viewModel),
                                const SizedBox(height: 8.0),
                                _buildAssignmentTitle(viewModel),
                                const SizedBox(height: 8.0),
                                _buildAssignmentDeadline(viewModel),
                                const SizedBox(height: 8.0),
                                _buildAssignmentDescription(viewModel),
                                const SizedBox(height: 8.0),
                                _buildReferenceMaterials(viewModel),
                                const SizedBox(height: 8.0),
                                if (widget.role == 'STUDENT')
                                  _buildMyWorkSection(viewModel),
                                const SizedBox(height: 8.0),
                                if (widget.role == 'STUDENT')
                                  _buildGradeSection(viewModel),
                                if (widget.role == 'LECTURER') ...[
                                  const Text(
                                    'Danh sách nộp bài:',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  _buildSearchBar(viewModel),
                                ],
                                if (widget.role == 'LECTURER')
                                  _buildResponseList(context, viewModel),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubmissionStatus(AssignmentDetailViewModel viewModel) {
    return viewModel.assignment.isSubmitted
        ? Text(
      'Đã nộp bài vào ${viewModel.formatDate(viewModel.submission.submissionTime)}',
      style: const TextStyle(color: Colors.red, fontSize: 16.0),
    )
        : const Text(
      'Chưa nộp bài',
      style: TextStyle(color: Colors.red, fontSize: 16.0),
    );
  }

  Widget _buildAssignmentTitle(AssignmentDetailViewModel viewModel) {
    return Text(
      viewModel.assignment.title,
      style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildAssignmentDeadline(AssignmentDetailViewModel viewModel) {
    return Text(
      'Đến hạn vào ${viewModel.formatDate(viewModel.assignment.deadline)}',
      style: const TextStyle(fontSize: 16.0),
    );
  }

  Widget _buildAssignmentDescription(AssignmentDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hướng dẫn:',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Text(
          viewModel.assignment.description.isNotEmpty
              ? viewModel.assignment.description
              : 'Không có',
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget _buildReferenceMaterials(AssignmentDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tài liệu tham khảo:',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        viewModel.assignment.fileUrl.isNotEmpty
            ? InkWell(
          onTap: () async {
            await launchUrl(Uri.parse(viewModel.assignment.fileUrl));
          },
          child: Text(
            viewModel.assignment.fileUrl,
            style: const TextStyle(
                fontSize: 16.0,
                color: Colors.blue,
                decoration: TextDecoration.underline),
          ),
        )
            : const Text(
          'Không có',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget _buildMyWorkSection(AssignmentDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Công việc của tôi:',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        if (widget.assignment.isSubmitted) ...[
          if (viewModel.submission.textResponse != '')
            Text(
              viewModel.submission.textResponse,
              style: const TextStyle(fontSize: 16.0),
            ),
          InkWell(
            onTap: () async {
              await launchUrl(Uri.parse(viewModel.submission.fileUrl ?? ''));
            },
            child: Text(
              viewModel.submission.fileUrl ?? '',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ] else if (widget.status == 'PASS_DUE') ...[
          const Text(
            'Không có',
            style: TextStyle(fontSize: 16.0),
          ),
        ] else ...[
          const SizedBox(height: 8.0),
          TextField(
            controller: viewModel.textController,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nhập bài làm',
              alignLabelWithHint: true,
            ),
            onChanged: (text) {
              viewModel.updateText(text);
            },
          ),
          if (viewModel.selectedFiles.isNotEmpty) ...[
            const SizedBox(height: 8.0),
            for (var file in viewModel.selectedFiles)
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.only(right: 13.0),
                      child: Text(
                        file.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Roboto',
                          color: Color(0xFF212121),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      viewModel.removeSelectedFile(file);
                    },
                  ),
                ],
              ),
          ],
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  FilePickerResult? result =
                  await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'pdf', 'doc'],
                  );

                  if (result != null) {
                    List<PlatformFile> files = result.files;
                    viewModel.updateSelectedFiles(files);
                  } else {
                    // User canceled the picker
                  }
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Đính kèm'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildGradeSection(AssignmentDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Điểm:',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Text(
          viewModel.submission.grade == null
              ? 'Không có'
              : '${viewModel.submission.grade} điểm',
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget _buildSearchBar(AssignmentDetailViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(20.0), // Border radius
        ),
        child: TextField(
          onChanged: (value) {
            viewModel.updateSearchQuery(value);
          },
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm theo tên sinh viên',
            filled: true,
            fillColor: Colors.white,
            // Background color inside the TextField
            border: InputBorder.none,
            // Remove the outline
            enabledBorder: InputBorder.none,
            // Remove the outline when enabled
            focusedBorder: InputBorder.none,
            // Remove the outline when focused
            prefixIcon: Icon(Icons.search, color: Colors.black),
            contentPadding:
            EdgeInsets.symmetric(vertical: 16.0), // Center vertically
          ),
          style: const TextStyle(color: Colors.black),
          textInputAction: TextInputAction.search,
        ),
      ),
    );
  }

  Widget _buildResponseList(
      BuildContext context, AssignmentDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        for (var response in viewModel.filteredResponseList)
          ResponseItem(
            name:
            '${response.studentAccount?.firstName} ${response.studentAccount?.lastName}',
            email: '${response.studentAccount?.email}',
            submissionTime: response.submissionTime,
            grade: response.grade,
            textResponse: response.textResponse,
            fileUrl: response.fileUrl,
            accountId: response.studentAccount!.accountId,
            onGradeChange: (double? newGrade) {
              viewModel.updateGrade(newGrade);
            },
            onSubmit: (String studentId) async {
              viewModel.returnGrade(response, studentId);
            },
          ),
      ],
    );
  }
}