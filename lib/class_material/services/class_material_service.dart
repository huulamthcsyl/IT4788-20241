import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:it4788_20241/auth/models/login_data.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:it4788_20241/auth/models/sign_up_data.dart';
import 'package:it4788_20241/auth/models/user_data.dart';
import 'package:it4788_20241/class_material/models/class_material_model.dart';
import 'package:it4788_20241/class_material/repositories/class_material_repository.dart';

class MaterialService {
  final _materialRepository = MaterialRepository();
  Future<List<ClassMaterial>> getClassMaterials(String token, String classCode) async
  {
      return await _materialRepository.getClassMaterial(token, classCode);
  }
}