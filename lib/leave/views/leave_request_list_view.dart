import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:it4788_20241/leave/viewmodels/leave_request_list_viewmodel.dart';

import '../widgets/leave_request_dialog.dart';

class LeaveRequestListPage extends StatefulWidget {
  final String classId;
  LeaveRequestListPage({required this.classId});

  @override
  _LeaveRequestListPageState createState() => _LeaveRequestListPageState();
}

class _LeaveRequestListPageState extends State<LeaveRequestListPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<LeaveRequestListViewModel>(context, listen: false);
      viewModel.classcode = widget.classId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LeaveRequestListViewModel>(context);
    final displayedLeaveRequests = viewModel.getDisplayedLeaveRequests(DateFormat('yyyy-MM-dd').format(_selectedDate));

    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.white),
          title: Text("Danh sách đơn xin nghỉ", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent,
          elevation: 4,
        ),
        body: Column(
          children: [
            Padding(
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
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        "Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
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
                    icon: Icon(Icons.calendar_today, size: 18),
                    label: Text("Chọn ngày"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: displayedLeaveRequests.isEmpty
                  ? Center(
                child: Text(
                  "Không có đơn xin nghỉ cho ngày này",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: displayedLeaveRequests.length,
                itemBuilder: (context, index) {
                  final item = displayedLeaveRequests[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.redAccent,
                            child: Text(
                              item.studentAccount.firstName[0],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${item.studentAccount.firstName} ${item.studentAccount.lastName}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item.status == "PENDING"
                                      ? "Chờ duyệt"
                                      : item.status == "ACCEPTED"
                                      ? "Chấp nhận"
                                      : "Từ chối",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: item.status == "PENDING"
                                        ? Colors.orange
                                        : item.status == "ACCEPTED"
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return LeaveRequestDetailsDialog(
                                    item: item,
                                    onAccept: () async {
                                      await viewModel.reviewAbsenceRequest(item.id, "ACCEPTED");
                                      viewModel.sendNotification(
                                        message: "Phản hồi về đơn xin nghỉ học",
                                        toUser: item.studentAccount.accountId,
                                        type: "ACCEPT_ABSENCE_REQUEST",
                                      );
                                      viewModel.fetchLeaveRequests();
                                      Navigator.of(context).pop();
                                    },
                                    onReject: () async {
                                      await viewModel.reviewAbsenceRequest(item.id, "REJECTED");
                                      viewModel.sendNotification(
                                        message: "Phản hồi về đơn xin nghỉ học",
                                        toUser: item.studentAccount.accountId,
                                        type: "REJECT_ABSENCE_REQUEST",
                                      );
                                      viewModel.fetchLeaveRequests();
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                              );
                            },
                            child: Text('Chi tiết', style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
