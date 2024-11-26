import 'package:it4788_20241/class_material/models/class_material_model.dart';
import 'package:it4788_20241/class_material/services/class_material_service.dart';
import 'package:it4788_20241/class_material/views/class_material_upload_view.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/class_survey/views/class_survey_view.dart';
import '../../auth/models/user_data.dart';
import '../../utils/get_data_user.dart';
import '../views/class_material_view.dart';
import '../repositories/class_material_repository.dart';
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
  void onClickTabBar(int index, BuildContext context){
      if (index == 0)
        Navigator.push((context), MaterialPageRoute(builder: (context) => ClassSurveyPage()));
      else {
        Navigator.push((context), MaterialPageRoute(builder: (context) => ClassMaterialPage()));
      }
  }
}