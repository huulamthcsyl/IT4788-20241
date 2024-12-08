import 'dart:io';

import 'package:flutter/material.dart';
import 'package:it4788_20241/profile/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
{
  Future<void> _pickImage() async {
  }
  @override
  Widget build(BuildContext context) {
    final _profileviewmodel = Provider.of<ProfileViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text((_profileviewmodel.userData.role == "LECTURER" ? "THÔNG TIN GIẢNG VIÊN" : "THÔNG TIN SINH VIÊN"), style: TextStyle(
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
                                      image: DecorationImage(image: AssetImage(_profileviewmodel.userData.avatar.toString().isNotEmpty ? 'assets/img/profile_wallpaper.jpg' : _profileviewmodel.userData.avatar.toString()), fit: BoxFit.cover))
                                  ),
                                ),
                                Positioned(right: -5, bottom: -5,
                                  child: Container(
                                    padding: EdgeInsets.all(2.5),
                                    decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.white.withOpacity(0.0)),
                                        borderRadius: BorderRadius.circular(45.0),
                                        color: Colors.white.withOpacity(0.0)),
                                      child: Icon(Icons.edit, color: Colors.orange)
                                  ),
                                ),
                                ],
                              ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(_profileviewmodel.userData.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(text: 'Email: ', style: TextStyle(fontSize: 14),),
                                              TextSpan(text: _profileviewmodel.userData.email, style: TextStyle(fontSize: 14, decorationColor: Colors.blue, color: Colors.blue, decoration: TextDecoration.underline)
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
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20)), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 10, offset: Offset(0, 3))]),
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: ProfileRow(title: (_profileviewmodel.userData.role == "LECTURER" ? "Mã giảng viên" : "Mã sinh viên"), value: _profileviewmodel.userData.id)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: ProfileRow(title: 'Email cá nhân:', value: _profileviewmodel.userData.email)),
                      ],
                    ),
                    /*SizedBox(height: 10),
                    ProfileRow(title: 'Khoa/Viện:', value: 'Trường Công nghệ Thông tin và Truyền thông'),
                    ProfileRow(title: 'Hệ:', value: 'Kỹ sư chính quy - K66'),
                    ProfileRow(title: 'Lớp:', value: 'Khoa học máy tính 04-K66'),
                    SizedBox(height: 20),*/
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _profileviewmodel.textError = '';
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ChangePasswordDialog();
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'ĐỔI MẬT KHẨU',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _profileviewmodel.logout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5, // Thêm độ cao bóng
                      ),
                      child: Text(
                        'ĐĂNG XUẤT',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
class ProfileRow extends StatelessWidget
{
  final String title;
  final String value;
  ProfileRow({required this.title, required this.value});
  @override
  Widget build(BuildContext context)
  {
    bool isGmail = value.contains('@gmail');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [ Text( title, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
          isGmail
              ? Text(value, style: TextStyle(fontSize: 18,color: Colors.blue.withOpacity(0.6),decoration: TextDecoration.underline, decorationColor: Colors.blue, fontWeight: FontWeight.bold),)
              : Text(value, style: TextStyle( fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
          Divider( color: Colors.grey, thickness: 1, height: 20),
        ],
      ),
    );
  }
}
class ChangePasswordDialog extends StatefulWidget {
  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _profileviewmodel = Provider.of<ProfileViewModel>(context);
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      title: Text('Đổi mật khẩu'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _oldPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Mật khẩu cũ',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Mật khẩu mới ${_profileviewmodel.userData.token}',
              border: OutlineInputBorder(),
            ),
          ),
          if (_profileviewmodel.textError.isNotEmpty)
          SizedBox(height: 5),
          if (_profileviewmodel.textError.isNotEmpty)
          Text(_profileviewmodel.textError, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),)
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.redAccent,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Hủy',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        ),
        SizedBox(width: 5)
        ,
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.lightGreen,
          ),
          onPressed: () {
            final oldPassword = _oldPasswordController.text.trim();
            final newPassword = _newPasswordController.text.trim();
            _profileviewmodel.changePassword(context, oldPassword, newPassword);

          },
          child: Text('Đổi mật khẩu', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        )
      ],
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}

