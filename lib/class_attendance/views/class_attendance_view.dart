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
          style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.redAccent,
      elevation: 4,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Provider.of<ClassAttendanceViewModel>(context, listen: false)
                .saveAttendance();
          },
          child: const Text(
            'Save',
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
                color: Colors.grey.shade100,
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
                style: const TextStyle(fontSize: 16, color: Colors.black87),
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
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.calendar_today, size: 18),
            label: const Text("Chọn ngày"),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ClassAttendanceViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: (value) {
          viewModel.updateSearchQuery(value);
        },
        decoration: const InputDecoration(
          labelText: 'Tìm kiếm theo email',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
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
              if (viewModel.attendanceList.isEmpty)
                ElevatedButton(
                  onPressed: () {
                    viewModel.clearSearchAndResetAttendance();
                  },
                  child: const Text('Điểm danh'),
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
