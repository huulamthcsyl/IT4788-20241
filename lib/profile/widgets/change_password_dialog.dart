import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/widgets/password_field.dart';
import '../../utils/validate_password.dart';
import '../viewmodels/profile_viewmodel.dart';

class ChangePasswordDialog extends StatefulWidget {
  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  @override
  Widget build(BuildContext context) {
    final _profileviewmodel = Provider.of<ProfileViewModel>(context);
    return AlertDialog(
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.white,
          width: 1,
        ),
      ),
      title: Center(
        child: Text(
          'ĐỔI MẬT KHẨU',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PasswordField(
              update: _profileviewmodel.updateOldPassword,
              hint: "Mật khẩu cũ",
              validate: validatePassword,
              controller: _profileviewmodel.oldPasswordController),
          SizedBox(height: 10),
          PasswordField(
              update: _profileviewmodel.updateNewPassword,
              hint: "Mật khẩu mới",
              validate: validatePassword,
              controller: _profileviewmodel.newPasswordController),
          SizedBox(height: 10),
          PasswordField(
              update: _profileviewmodel.updateReNewPassword,
              hint: "Xác nhận mật khẩu mới",
              validate: validatePassword,
              controller: _profileviewmodel.reNewPasswordController),
          if (_profileviewmodel.textError.isNotEmpty) SizedBox(height: 5),
          if (_profileviewmodel.textError.isNotEmpty)
            Text(
              _profileviewmodel.textError,
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            )
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
          child: Text(
            'Hủy',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(width: 5),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.lightGreen,
          ),
          onPressed: () {
            _profileviewmodel.changePassword(context);
          },
          child: Text('Đổi mật khẩu',
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
