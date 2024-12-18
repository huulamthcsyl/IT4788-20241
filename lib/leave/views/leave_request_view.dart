import 'package:flutter/material.dart';
import 'package:it4788_20241/classCtrl/models/class_data.dart';
import 'package:provider/provider.dart';
import '../viewmodels/leave_request_viewmodel.dart';

class LeaveRequestPage extends StatelessWidget {
  final String className, classId; // Nhận classId từ màn hình trước
  LeaveRequestPage({required this.className, required this.classId});

  @override
  Widget build(BuildContext context) {
    final leaveRequestViewModel = Provider.of<LeaveRequestViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.red,
        title: Center(
          child: Text('Nghỉ phép          ', style: TextStyle(color: Colors.white)),
        ),
        iconTheme: IconThemeData(color: Colors.white),
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
            Text("Mã lớp :${classId}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            SizedBox(width: 10,),
            Text("Tên lớp :${className}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            SizedBox(width: 10,),
            TextField(
              controller: leaveRequestViewModel.titleController,
              decoration: InputDecoration(
                labelText: 'Tiêu đề',
                labelStyle: TextStyle(color: Colors.red), // Màu chữ cho label
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), // Màu viền trắng
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), // Màu viền trắng khi focus
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), // Màu viền trắng khi không focus
                ),
                //contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                hintStyle: TextStyle(color: Colors.red, fontSize: 20.0,), // Màu chữ khi nhập
              ),
              style: TextStyle(color: Colors.black), // Màu chữ nhập
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: leaveRequestViewModel.reasonController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Lý do',
                labelStyle: TextStyle(color: Colors.red), // Màu chữ cho label
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), // Màu viền trắng
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), // Màu viền trắng khi focus
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), // Màu viền trắng khi không focus
                ),
                //contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                hintStyle: TextStyle(color: Colors.red, fontSize: 16.0,), // Màu chữ khi nhập
              ),
              style: TextStyle(color: Colors.black), // Màu chữ nhập
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: leaveRequestViewModel.proofImage == null
                  ? () => leaveRequestViewModel.pickImage()
                  : null,
              icon: Icon(Icons.upload, color: Colors.white,),
              style: ElevatedButton.styleFrom(
                backgroundColor: leaveRequestViewModel.proofImage == null ? Colors.red : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0), // Viền ít cong hơn
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ),
              label: Text(leaveRequestViewModel.proofImage == null ? 'Tải minh chứng' : 'Đã tải minh chứng',
                style: TextStyle(color: Colors.white, fontSize: 20.0,),
              ),
            ),
            if (leaveRequestViewModel.proofImage != null) ...[
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => leaveRequestViewModel.previewImage(context),
                    child: Text(
                      leaveRequestViewModel.proofImage!.name,
                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () => leaveRequestViewModel.removeImage(),
                  ),
                ],
              ),
            ],
            SizedBox(height: 16.0),
            TextField(
              controller: leaveRequestViewModel.dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Ngày nghỉ phép',
                labelStyle: TextStyle(color: Colors.red), // Màu chữ cho label
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), // Màu viền trắng
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), // Màu viền trắng khi focus
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), // Màu viền trắng khi không focus
                ),
                //contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                hintStyle: TextStyle(color: Colors.red, fontSize: 20.0,), // Màu chữ khi nhập
              ),
              style: TextStyle(color: Colors.black), // Màu chữ nhập
              onTap: () => leaveRequestViewModel.pickDate(context),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await leaveRequestViewModel.submitRequest(classId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gửi đơn xin nghỉ thành công!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Màu nền đỏ
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0), // Viền ít cong hơn
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              ),
              child: Text('Gửi',
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
