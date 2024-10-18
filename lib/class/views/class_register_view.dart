import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/class_register_viewmodel.dart';

class RegisterClassPage extends StatelessWidget {
  final TextEditingController _classCodeController = TextEditingController();
  ScrollController _horizontalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClassRegisterViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Center(
          child: Text(
            'Đăng ký lớp học',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        // Sử dụng Container để kiểm soát kích thước của giao diện
        width: double.infinity,
        height: MediaQuery.of(context).size.height, // Đặt chiều cao bằng chiều cao màn hình
        child: Column(
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
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5, // Chiều rộng tương ứng với khoảng 10 ký tự
                      child: TextField(
                        controller: _classCodeController,
                        decoration: InputDecoration(
                          labelText: 'Nhập mã lớp học',
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
                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                          hintStyle: TextStyle(color: Colors.red, fontSize: 20.0,), // Màu chữ khi nhập
                        ),
                        style: TextStyle(color: Colors.red), // Màu chữ nhập
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.addClass(_classCodeController.text);
                      _classCodeController.clear(); // Xóa nội dung sau khi đăng ký
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Màu nền đỏ
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0), // Viền ít cong hơn
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    ),
                    child: Text('Đăng ký',
                      style: TextStyle(color: Colors.white, fontSize: 20.0,),
                    ),
                  ),
                ],
              ),
            ),

            viewModel.registeredClasses.isEmpty
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Bạn chưa đăng ký lớp học nào',
                style: TextStyle(color: Colors.red, fontSize: 18.0),
              ),
            )
                :
            Expanded(
              child: SingleChildScrollView(
               child: Column(
                children: [
                 Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Đặt khoảng cách lề cho bảng
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Đảm bảo cuộn ngang
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical, // Đảm bảo cuộn dọc
                    child: Container(
                      width: MediaQuery.of(context).size.width * 2.5, // Rộng hơn màn hình để có thể cuộn ngang
                      child: Table(
                        border: TableBorder.all(color: Colors.black), // Viền bảng màu đen
                        columnWidths: const <int, TableColumnWidth>{
                          0: FixedColumnWidth(80),
                          1: FixedColumnWidth(80),
                          2: FixedColumnWidth(80),
                          3: FixedColumnWidth(150),
                          4: FixedColumnWidth(150),
                          5: FixedColumnWidth(100),
                          6: FixedColumnWidth(50),
                          7: FixedColumnWidth(80),
                          8: FixedColumnWidth(100),
                          9: FixedColumnWidth(50),
                        },
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.red, // Nền màu đỏ cho hàng tiêu đề
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                                child: Center(child: Text('Mã lớp', style: TextStyle(color: Colors.white))),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                                child: Center(child: Text('Mã lớp kèm', style: TextStyle(color: Colors.white))),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                                child: Center(child: Text('Mã HP', style: TextStyle(color: Colors.white))),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                                child: Center(child: Text('Tên lớp', style: TextStyle(color: Colors.white))),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                                child: Center(child: Text('Lịch học', style: TextStyle(color: Colors.white))),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                                child: Center(child: Text('Phòng học', style: TextStyle(color: Colors.white))),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                                child: Center(child: Text('Số TC', style: TextStyle(color: Colors.white))),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                                child: Center(child: Text('Loại lớp', style: TextStyle(color: Colors.white))),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                                child: Center(child: Text('Trạng thái', style: TextStyle(color: Colors.white))),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
                                child: Center(child: Text('Xóa', style: TextStyle(color: Colors.white))),
                              ),
                            ],
                          ),
                          for (int i = 0; i < viewModel.registeredClasses.length; i++)
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(0.0), // Thêm padding cho chữ trong bảng
                                  child: Center(child: Text(viewModel.registeredClasses[i].classCode)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Center(child: Text(viewModel.registeredClasses[i].linkedClassCode)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Center(child: Text(viewModel.registeredClasses[i].courseCode)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Center(child: Text(viewModel.registeredClasses[i].className)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Center(child: Text(viewModel.registeredClasses[i].schedule)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Center(child: Text(viewModel.registeredClasses[i].classroom)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Center(child: Text(viewModel.registeredClasses[i].credits.toString())),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Center(child: Text(viewModel.registeredClasses[i].classType)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Center(child: Text(viewModel.registeredClasses[i].status)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        viewModel.deleteClassTemporarily(i);  // Xóa tạm thời
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),



            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                children: [ Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nút "Gửi đăng ký"
                  ElevatedButton(
                    onPressed: viewModel.submitRegistration, // Gửi đăng ký
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Màu nền đỏ
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0), // Viền ít cong hơn
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    ),
                    child: Text('Gửi đăng ký',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  ],
                ),

                ],
              ),

            ),

          ],
        ),
      ),
    ),
            // Dòng chữ "Thông tin danh sách các lớp mở"
            SizedBox(height: 10.0), // Khoảng cách giữa nút và dòng chữ
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/class-list');  // Sử dụng route name để điều hướng
              },
              child: Text(
                'Thông tin danh sách các lớp mở',
                style: TextStyle(
                  color: Colors.red, // Màu đỏ
                  fontStyle: FontStyle.italic, // In nghiêng
                  decoration: TextDecoration.underline, // Gạch chân
                ),
              ),
            ),
        ]
      ),
    ),
    );
  }
}
