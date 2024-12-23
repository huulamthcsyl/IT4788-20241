import 'package:flutter/material.dart';
import 'package:it4788_20241/profile/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';

import '../widgets/change_password_dialog.dart';
import '../widgets/user_information_card.dart';
import '../widgets/user_main_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final _profileviewmodel = Provider.of<ProfileViewModel>(context);
    setState(() {
      _profileviewmodel.initUserData();
    });
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
          centerTitle: true,
        title: Center(
            child: Text(
              (_profileviewmodel.userData.role == "LECTURER"
                  ? "THÔNG TIN GIẢNG VIÊN"
                  : "THÔNG TIN SINH VIÊN"),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),
            )),
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
                  child: UserMainCard(),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: UserInformationCard(),
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
                        _profileviewmodel.updateOldPassword('');
                        _profileviewmodel.oldPasswordController.text = '';
                        _profileviewmodel.reNewPasswordController.text = '';
                        _profileviewmodel.newPasswordController.text = '';
                        _profileviewmodel.updateNewPassword('');
                        _profileviewmodel.updateReNewPassword('');
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
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
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