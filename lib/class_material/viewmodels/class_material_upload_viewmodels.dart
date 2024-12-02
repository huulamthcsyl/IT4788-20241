import 'dart:io';
import 'package:it4788_20241/class_material/services/class_material_service.dart';
import 'package:flutter/material.dart';
import '../../auth/models/user_data.dart';
import '../../utils/get_data_user.dart';
class ClassMaterialUploadViewModel extends ChangeNotifier
{
  ClassMaterialUploadViewModel() {
    initUserData();
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
  void initUserData() async {
    userData = await getUserData();
    notifyListeners();
  }
  String filePath = "";
  String title = "";
  String description = "";
  String materialType = "";
  bool isUploading = false;
  double progress = 0.0;
  final _materialUploadService = MaterialService();
  void uploadFile() async {
    if (File(filePath) == null || title.isEmpty || description.isEmpty || materialType.isEmpty) {
      return;
    }
   await _materialUploadService.uploadFile(token: userData.token, classId: "000089", title: title, description: description, materialType: materialType, file: File(filePath));
  }

}