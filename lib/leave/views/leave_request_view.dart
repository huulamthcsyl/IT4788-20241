import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/leave_request_viewmodel.dart';

class LeaveRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final leaveRequestViewModel = Provider.of<LeaveRequestViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.red,
        title: Center(
          child: Text(
            'Nghỉ phép',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Column(
          children: [
            Container(
              color: Colors.red, // Màu nền đỏ cho toàn bộ phần
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0), // Giảm khoảng cách trên và dưới
              child: Center( // Đặt ảnh vào giữa
                child: Image(
                  image: AssetImage('assets/img/logo_hust_white.png'),
                  width: MediaQuery.of(context).size.width * 0.4, // Chiều rộng bằng một nửa màn hình
                ),
              ),
            ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: leaveRequestViewModel.titleController,
              decoration: InputDecoration(
                hintText: 'Tiêu đề',
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Màu viền khi focus
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: leaveRequestViewModel.reasonController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Lý do',
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Màu viền khi focus
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () => leaveRequestViewModel.pickImage(),
              icon: Icon(Icons.upload, color: Colors.white,),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Màu nền đỏ
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0), // Viền ít cong hơn
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ),
              label: Text('Tải minh chứng',
                style: TextStyle(color: Colors.white, fontSize: 20.0,),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: leaveRequestViewModel.dateController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Ngày nghỉ phép',
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Màu viền khi focus
                ),
              ),
              onTap: () => leaveRequestViewModel.pickDate(context),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => leaveRequestViewModel.submitRequest(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Màu nền đỏ
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0), // Viền ít cong hơn
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ),
              child: Text('Submit',
                style: TextStyle(color: Colors.white, fontSize: 20.0,),
              ),
            ),
          ],
        ),
      ),
    ]
    ),
    );
  }
}
