import 'dart:io';
import 'package:it4788_20241/class_material/models/class_material_model.dart';
import 'package:it4788_20241/class_material/repositories/class_material_repository.dart';

class MaterialService {
  final _materialRepository = MaterialRepository();
  Future<List<ClassMaterial>> getClassMaterials(String? token, String classCode) async
  {
      return await _materialRepository.getClassMaterial(token, classCode);
  }
  Future<void> deleteMaterial({required String? token, required String material_id}) async{
    await _materialRepository.deleteMaterial(token: token, material_id: material_id);
  }
  Future<void> uploadFile({
    required String? token,
    required String classId,
    required String title,
    required String description,
    required String materialType,
    required File file,
  }) async{
    // Xử lý logic
    await _materialRepository.uploadFile(token: token, classId: classId, title: title, description: description, materialType: materialType, file: file);
  }
}