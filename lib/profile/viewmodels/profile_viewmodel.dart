import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:it4788_20241/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../auth/models/user_data.dart';
import '../../utils/get_data_user.dart';
class ProfileViewModel extends ChangeNotifier
{
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController reNewPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  String? old_password;
  String? new_password;
  String? re_new_password;
  void updateOldPassword(String oldpassword) {
    old_password = oldpassword;
    notifyListeners();
  }
  void updateNewPassword(String newpassword) {
    new_password = newpassword;
    notifyListeners();
  }
  void updateReNewPassword(String re_newpassword) {
    re_new_password = re_newpassword;
    notifyListeners();
  }

  ProfileViewModel() {
    initUserData();
    old_password = '';
    new_password = '';
    re_new_password = '';
  }
  UserData userData = UserData(
    id: '',
    ho: '',
    ten: '',
    name: '',
    email: '',
    token: '',
    status: '',
    role: '',
    avatar: '',
  );
  UserData searchUserData = UserData(
    id: '',
    ho: '',
    ten: '',
    name: '',
    email: '',
    token: '',
    status: '',
    role: '',
    avatar: '',
  );
  void initUserData() async {
    userData = await getUserData();
    notifyListeners();
  }

  void logout(BuildContext context) async {
    await _authService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
  void getInformationFromUser(int id) async {
    searchUserData = await _authService.getUserInfo(id.toString());
    notifyListeners();
  }
  String textError = '';
  void changePassword(BuildContext context) async {
    if (old_password == null || old_password!.isEmpty) {
      textError = "Chưa điền mật khẩu cũ";
      notifyListeners();
      return;
    }

    if (new_password == null || new_password!.isEmpty) {
      textError = "Chưa điền mật khẩu mới";
      notifyListeners();
      return;
    }

    if (old_password == new_password) {
      textError = "Mật khẩu mới không thể giống mật khẩu cũ";
      notifyListeners();
      return;
    }

    if (new_password!.contains(old_password!)) {
      textError = "Mật khẩu mới không thể quá giống mật khẩu cũ";
      notifyListeners();
      return;
    }

    if (re_new_password != new_password) {
      textError = "Mật khẩu nhập lại không khớp!";
      notifyListeners();
      return;
    }

    final token = (await getUserData()).token ?? "";
    await _authService.changePassword(token: token, old_password: old_password!, new_password: new_password!);
    Navigator.of(context).pop();
    showSuccessToast(context);
  }
  void showSuccessToast(BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Đổi mật khẩu thành công!',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  ImagePicker _picker = ImagePicker();
  File filePicked = File('');

  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      filePicked = File(pickedFile.path);
      notifyListeners();
    }
  }

  String convertGoogleDriveLink(String link) {
    final regex = RegExp(r'd/([a-zA-Z0-9_-]+)/view');
    final match = regex.firstMatch(link);
    if (match != null && match.groupCount >= 1) {
      final fileId = match.group(1);
      return 'https://drive.google.com/uc?export=view&id=$fileId';
    }
    return link;
  }
  void changeAvatar(BuildContext context, File image) async {
    if (!context.mounted) return;
    final token = (await getUserData()).token ?? "";
    Navigator.of(context).pop();
    await _authService.changeAvatar(token: token, file: image);
    userData = await getUserData();
    notifyListeners();
  }

}