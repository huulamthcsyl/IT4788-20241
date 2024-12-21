import 'package:flutter/material.dart';
import 'package:it4788_20241/class_assignment/models/assignment_data.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:it4788_20241/class_assignment/viewmodels/create_assignment_viewmodel.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';

class CreateAssignmentDialog extends StatelessWidget {
  final ClassData classData;
  final AssignmentData? assignmentData;

  const CreateAssignmentDialog({super.key, required this.classData, this.assignmentData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateAssignmentViewModel(classData, assignmentData),
      child: Consumer<CreateAssignmentViewModel>(
        builder: (context, viewModel, child) {
          return AlertDialog(
            title: Text(assignmentData == null ? 'Tạo bài tập mới' : 'Chỉnh sửa bài tập'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: viewModel.titleController,
                    decoration: InputDecoration(
                      labelText: 'Tiêu đề',
                      errorText: viewModel.titleError,
                    ),
                    onChanged: (text) {
                      viewModel.updateTitle(text);
                    },
                    readOnly: assignmentData != null, // Make the title read-only if editing
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: viewModel.descriptionController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mô tả',
                      alignLabelWithHint: true,
                    ),
                    onChanged: (text) {
                      viewModel.updateDescription(text);
                    },
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
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
                    child: const Text('Chọn file đính kèm'),
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
                                  fontWeight: FontWeight.bold,
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
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          final selectedDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          viewModel.updateSelectedDate(selectedDateTime);
                        }
                      }
                    },
                    child: Text('Chọn ngày đến hạn'),
                  ),
                  if (viewModel.selectedDate != null)
                    Text(
                        'Ngày đến hạn: ${viewModel.formatDate(viewModel.selectedDate!)}'),
                  if (viewModel.dateError != null)
                    Text(
                      viewModel.dateError!,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  viewModel.createAssignment();
                  if (viewModel.titleError == null && viewModel.dateError == null) {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(assignmentData == null ? 'Tạo' : 'Cập nhật'),
              ),
            ],
          );
        },
      ),
    );
  }
}