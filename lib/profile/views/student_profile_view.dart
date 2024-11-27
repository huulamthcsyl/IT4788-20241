import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
class StudentProfilePage extends StatefulWidget {
  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage>
{
  Future<void> _pickImage() async {
    // Mở hộp thoại chọn ảnh

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('Thông tin sinh viên', style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),)
        ),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 160,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage('assets/img/profile_wallpaper.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 16,
                  right: 16,
                  child: Card(
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Column(
                        children: [
                          Stack(
                             children: [
                               Row(
                                  children: [
                                  Stack(
                                  children: [
                                  ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    height: 100.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/img/profile_wallpaper.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: -5,
                                  bottom: -5,
                                  child: Container(
                                    padding: EdgeInsets.all(2.5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.white.withOpacity(0.0),
                                      ),
                                      borderRadius: BorderRadius.circular(45.0),
                                      color: Colors.white.withOpacity(0.0),
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                                ],
                              ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Lê Hà Anh Đức',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'SĐT: ',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              TextSpan(
                                                text: '0966950761',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue,
                                                  decorationColor: Colors.blue,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Email: ',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              TextSpan(
                                                text: 'duc.lha215351@sis.hust.edu.vn',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  decorationColor: Colors.blue,
                                                  color: Colors.blue,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                    )
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 1, // Sửa lại tỷ lệ chiều rộng
                child: Column(
                  children: [
                    // Dòng đầu tiên chia thành 2 cột
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ProfileRow(title: 'Mã sinh viên:', value: '20215351'),
                        ),
                        SizedBox(width: 10), // Khoảng cách giữa 2 cột
                        Expanded(
                          child: ProfileRow(title: 'Ngày sinh:', value: '17/02/2003'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // Khoảng cách giữa các hàng
                    // Dòng thứ hai
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ProfileRow(title: 'Email cá nhân:', value: 'fantasys3142@gmail.com'),
                        ),
                        SizedBox(width: 10), // Khoảng cách giữa 2 cột
                        Expanded(
                          child: ProfileRow(title: 'Số điện thoại:', value: '0966950761'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Các hàng còn lại
                    ProfileRow(
                        title: 'Khoa/Viện:',
                        value: 'Trường Công nghệ Thông tin và Truyền thông'),
                    ProfileRow(title: 'Hệ:', value: 'Kỹ sư chính quy - K66'),
                    ProfileRow(title: 'Lớp:', value: 'Khoa học máy tính 04-K66'),
                    SizedBox(height: 20),

                    // Nút Log out
                    SizedBox(
                      width: double.infinity, // Đặt độ rộng bằng với Card
                      child: ElevatedButton(
                        onPressed: () {
                          // Thêm logic để đăng xuất ở đây
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Màu nền của nút
                          padding: EdgeInsets.symmetric(vertical: 15), // Khoảng cách bên trong nút
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Bo tròn các góc
                          ),
                        ),
                        child: Text(
                          'ĐĂNG XUẤT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
class ProfileRow extends StatelessWidget {
  final String title;
  final String value;

  ProfileRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem value có chứa "@gmail" không
    bool isGmail = value.contains('@gmail');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          ),
          isGmail
              ? Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue.withOpacity(0.6),
              decoration: TextDecoration.underline,
              decorationColor: Colors.blue,
              fontWeight: FontWeight.bold
            ),
          )
              : Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black, // Màu chữ khi không có @gmail
              fontWeight: FontWeight.bold, // Không đậm
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
            height: 20,
          ),
        ],
      ),
    );
  }
}

