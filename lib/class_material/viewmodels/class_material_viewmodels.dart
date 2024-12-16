import 'dart:io';

import 'package:it4788_20241/class_another_function/views/class_function_view.dart';
import 'package:it4788_20241/class_material/models/class_material_model.dart';
import 'package:it4788_20241/class_material/services/class_material_service.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/class_survey/views/class_survey_view.dart';
import '../../auth/models/user_data.dart';
import '../../utils/get_data_user.dart';
import '../views/class_material_view.dart';
class ClassMaterialViewModel extends ChangeNotifier
{
  ClassMaterialViewModel() {
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
  final _materialService = MaterialService();
  late List<ClassMaterial> _listClassMaterial;
  Future<void> getClassMaterials(String classCode) async {

    _listClassMaterial = await _materialService.getClassMaterials(userData.token, classCode);
    notifyListeners();
  }
  List<ClassMaterial> getMaterialList(){
    return _listClassMaterial;
  }
  Future<void> deleteMaterial(ClassMaterial classMaterial) async{

      await _materialService.deleteMaterial(token: userData.token, material_id: classMaterial.ID.toString());
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
  String old_material_id = '';
  void editFile() async {
    if (File(filePath) == null || title.isEmpty || description.isEmpty || materialType.isEmpty) {
      return;
    }
    await _materialUploadService.editFile(token: userData.token, materialId: old_material_id, title: title, description: description, materialType: materialType, file: File(filePath));
  }
  void onClickTabBar(int index, BuildContext context){
    switch (index){
      case 0:
      // Route to class_survey
        Navigator.push((context), MaterialPageRoute(builder: (context) => ClassSurveyPage()));
        break;
      case 1:
      // Route to class_material
        Navigator.push((context), MaterialPageRoute(builder: (context) => ClassMaterialPage()));
        break;
      case 2:
      // Route to class_another_function
    Navigator.push((context), MaterialPageRoute(builder: (context) => ClassFunctionPage()));
        break;
    }
  }
}