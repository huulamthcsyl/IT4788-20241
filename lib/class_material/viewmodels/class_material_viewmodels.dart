import 'package:it4788_20241/class_material/models/class_material_model.dart';
import 'package:it4788_20241/class_material/views/class_material_upload_view.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/class_survey/views/class_survey_view.dart';
import '../views/class_material_view.dart';
import '../repositories/class_material_repository.dart';
class ClassMaterialViewModel extends ChangeNotifier
{
  late List<ClassMaterial> _classes;

  List<ClassMaterial> getClassMaterials(String classCode) {
    // Trong trường hợp có Database rồi thì truy vấn database để lấy file dựa trên classCode

    return ;
  }
  void onClickTabBar(int index, BuildContext context){
      if (index == 0)
        Navigator.push((context), MaterialPageRoute(builder: (context) => ClassSurveyPage()));
      else {
        Navigator.push((context), MaterialPageRoute(builder: (context) => ClassMaterialPage()));
      }
  }
}