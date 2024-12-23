import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:it4788_20241/class_attendance/viewmodels/class_attendance_viewmodel.dart';
import 'package:it4788_20241/class_attendance/widgets/attendance_item.dart';
import 'package:provider/provider.dart';

class ClassAttendanceView extends StatefulWidget {
  final ClassData classData;

  const ClassAttendanceView({super.key, required this.classData});

  @override
  ClassAttendanceViewState createState() => ClassAttendanceViewState();
}

class ClassAttendanceViewState extends State<ClassAttendanceView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel =
          Provider.of<ClassAttendanceViewModel>(context, listen: false);
      viewModel.setClassData(widget.classData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassAttendanceViewModel>(context);

    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildDateSelector(viewModel),
            _buildSearchBar(viewModel),
            _buildAttendanceList(viewModel),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const BackButton(color: Colors.white),
      title: const Text("Danh sách điểm danh",
          style: TextStyle(color: Colors.white, fontSize: 20)),
      backgroundColor: Colors.red,
      centerTitle: true,
      elevation: 4,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Provider.of<ClassAttendanceViewModel>(context, listen: false)
                .saveAttendance();
          },
          child: const Text(
            'Lưu',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(ClassAttendanceViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Text(
                "Ngày: ${DateFormat('dd/MM/yyyy').format(viewModel.selectedDate)}",
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: viewModel.selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                viewModel.updateSelectedDate(pickedDate);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.calendar_today, size: 18),
            label: const Text(
              "Chọn ngày",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ClassAttendanceViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(20.0), // Border radius
        ),
        child: TextField(
          onChanged: (value) {
            viewModel.updateSearchQuery(value);
          },
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm theo email',
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
            contentPadding: EdgeInsets.symmetric(vertical: 16.0), // Center vertically
          ),
          style: const TextStyle(color: Colors.black),
          textInputAction: TextInputAction.search,
        ),
      ),
    );
  }

  Widget _buildAttendanceList(ClassAttendanceViewModel viewModel) {
    if (viewModel.filteredAttendanceList.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Không có thông tin điểm danh.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 8.0),
              if (viewModel.attendanceList.isEmpty)
                ElevatedButton(
                  onPressed: () {
                    viewModel.clearSearchAndResetAttendance();
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
                    'Điểm danh',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
            ],
          ),
        ),
      );
    } else {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            itemCount: viewModel.filteredAttendanceList.length,
            itemBuilder: (context, index) {
              final student = viewModel.filteredAttendanceList[index];
              return AttendanceItem(
                name: student['name']!,
                email: student['email']!,
                status: student['status']!,
                onStatusChange: (status) {
                  viewModel.updateAttendanceStatus(student['email']!, status);
                },
              );
            },
          ),
        ),
      );
    }
  }
}
