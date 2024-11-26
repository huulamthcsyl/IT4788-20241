import 'package:flutter/cupertino.dart';

class ClassMaterial{
  int ID;
  String class_id;
  String material_name;
  String description;
  String material_type;

  ClassMaterial({
    required this.ID,
    required this.class_id,
    required this.material_name,
    required this.description,
    required this.material_type
  });
  factory ClassMaterial.fromJson(Map<String, dynamic> json){
    return ClassMaterial(
      ID: json['id'],
      class_id: json['class_id'],
      material_name: json['material_name'],
      description: json['description'],
      material_type: json['material_type'],
    );
  }
}