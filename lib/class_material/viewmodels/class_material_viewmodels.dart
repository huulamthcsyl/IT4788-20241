import 'package:it4788_20241/class_material/models/class_material_model.dart';
import 'package:it4788_20241/class_material/views/class_material_upload_view.dart';
import 'package:flutter/material.dart';
import 'package:it4788_20241/class_survey/views/class_survey_view.dart';
import '../views/class_material_view.dart';
class ClassMaterialViewModel extends ChangeNotifier
{
  late List<ClassMaterial> _classes;

  List<ClassMaterial> getClassMaterials(String classCode) {
    List<ClassMaterial> listMaterial = List.generate(10, (index) => ClassMaterial(
        fileName: 'class_material${index + 1}.docx',
        fileDescription: 'class Materials',
        dateModified: DateTime.now(),
        classCode: classCode  // Use the classCode parameter here
    ));
    return listMaterial;
  }
  void onClickTabBar(int index, BuildContext context){
      if (index == 0)
        Navigator.push((context), MaterialPageRoute(builder: (context) => ClassSurveyPage()));
      else {
        Navigator.push((context), MaterialPageRoute(builder: (context) => ClassMaterialPage()));
      }
  }
}