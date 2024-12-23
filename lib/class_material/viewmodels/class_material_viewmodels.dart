import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:it4788_20241/class_another_function/views/class_function_view.dart';
import 'package:it4788_20241/class_assignment/views/assignment_list_view.dart';
import 'package:it4788_20241/class_material/models/class_material_model.dart';
import 'package:it4788_20241/class_material/services/class_material_service.dart';
import 'package:flutter/material.dart';
import '../../auth/models/user_data.dart';
import '../../classCtrl/models/class_data.dart';
import '../../utils/get_data_user.dart';
import '../views/class_material_view.dart';
import 'package:file_picker/file_picker.dart';

class ClassMaterialViewModel extends ChangeNotifier {
  ClassMaterialViewModel() {
    initUserData();
  }

  ClassData classData = ClassData(classId: '', classCode: '', className: '', maxStudents: 0, classType: '', status: '', studentAccounts: []);

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
  List<ClassMaterial> _listClassMaterial = [];
  Future<void> getClassMaterials(String classId) async {
    final token = (await getUserData()).token ?? "";
    _listClassMaterial = await _materialService.getClassMaterials(token, classId);
    notifyListeners();
  }

  List<ClassMaterial> getMaterialList() {
    return _listClassMaterial;
  }

  Future<void> deleteMaterial(ClassMaterial classMaterial) async {
    await _materialService.deleteMaterial(token: userData.token, material_id: classMaterial.ID.toString());
    _listClassMaterial.remove(classMaterial);
    notifyListeners();
  }

  String filePath = "";
  String title = "";
  String description = "";
  String materialType = "";
  bool isUploading = false;
  double progress = 0.0;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void resetUploadFields() {
    filePath = "";
    title = "";
    description = "";
    materialType = "";
    isUploading = false;
    progress = 0.0;
    titleController.clear();
    descriptionController.clear();
    notifyListeners();
  }

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    filePath = result.files.single.path!;
    notifyListeners();
  }

  void clearPickedFile() {
    filePath = "";
    notifyListeners();
  }

  Future<void> uploadFile() async {
    if (filePath.isEmpty || titleController.text.isEmpty || descriptionController.text.isEmpty) {
      return;
    }
    title = titleController.text;
    description = descriptionController.text;
    isUploading = true;
    notifyListeners();
    try {
      await _materialService.uploadFile(
          token: userData.token,
          classId: classData.classId,
          title: title,
          description: description,
          materialType: path.extension(filePath).toUpperCase(),
          file: File(filePath));
      await getClassMaterials(classData.classId);
    } catch (e) {
      print("Error during file upload: $e");
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  String old_material_id = '';

  void setMaterialForEdit(ClassMaterial material) {
    old_material_id = material.ID.toString();
    title = material.material_name;
    description = material.description;
    filePath = "";
    titleController.text = material.material_name;
    descriptionController.text = material.description;
    notifyListeners();
  }

  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
  }

  Future<void> editFile() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      return;
    }
    if (filePath.isEmpty) {
      print("Please select a file to edit.");
      return;
    }

    title = titleController.text;
    description = descriptionController.text;
    isUploading = true;
    notifyListeners();

    try {
      await _materialService.editFile(
        token: userData.token,
        materialId: old_material_id,
        title: title,
        description: description,
        materialType: path.extension(filePath).toUpperCase(),
        file: File(filePath),
      );
      await getClassMaterials(classData.classId);
    } catch (e) {
      print("Error during file edit: $e");
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  void onClickTabBar(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.push((context), MaterialPageRoute(builder: (context) => AssignmentListView(classData: classData)));
        break;
      case 1:
        Navigator.push((context), MaterialPageRoute(builder: (context) => ClassMaterialPage(classData: classData,)));
        break;
      case 2:
        Navigator.push((context), MaterialPageRoute(builder: (context) => ClassFunctionPage(classData: classData)));
        break;
    }
  }
}