import 'package:flutter/material.dart';
import 'package:it4788_20241/class_assignment/models/assignment_data.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:it4788_20241/class_assignment/viewmodels/create_assignment_viewmodel.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';

class CreateAssignmentDialog extends StatelessWidget {
  final ClassData classData;
  final AssignmentData? assignmentData;

  const CreateAssignmentDialog(
      {super.key, required this.classData, this.assignmentData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateAssignmentViewModel(classData, assignmentData),
      child: Consumer<CreateAssignmentViewModel>(
        builder: (context, viewModel, child) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFAFAFA),
            // Set background color to a lighter shade
            title: Text(
              assignmentData == null ? 'Tạo bài tập mới' : 'Chỉnh sửa bài tập',
              style: const TextStyle(
                  fontWeight: FontWeight.bold), // Make title bold
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8.0), // Border radius
                    ),
                    child: TextField(
                      controller: viewModel.titleController,
                      decoration: InputDecoration(
                        hintText: 'Tiêu đề',
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        // Remove the outline
                        enabledBorder: InputBorder.none,
                        // Remove the outline when enabled
                        focusedBorder: InputBorder.none,
                        // Remove the outline when focused
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 12.0),
                        // Add horizontal padding
                        errorText: viewModel.titleError,
                      ),
                      onChanged: (text) {
                        viewModel.updateTitle(text);
                      },
                      readOnly: assignmentData !=
                          null, // Make the title read-only if editing
                    ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                      textStyle: const TextStyle(fontSize: 18.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    icon: const Icon(Icons.attach_file, color: Colors.black),
                    label: const Text(
                      'Chọn file đính kèm',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    ),
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
                                  // fontWeight: FontWeight.bold,
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
                  ElevatedButton.icon(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                      textStyle: const TextStyle(fontSize: 18.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    icon: const Icon(Icons.calendar_today, color: Colors.black),
                    label: const Text(
                      'Chọn hạn nộp',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    ),
                  ),
                  if (viewModel.selectedDate != null)
                    Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        viewModel.formatDate(viewModel.selectedDate!),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                  // Background color for "Hủy" button
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Hủy',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () {
                        viewModel.createAssignment(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.withOpacity(0.8),
                  // Background color for "Tạo" button
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  textStyle: const TextStyle(fontSize: 18.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: viewModel.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2.0,
                        ),
                      )
                    : Text(
                        assignmentData == null ? 'Tạo' : 'Cập nhật',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
