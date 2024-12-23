class ClassMaterial{
  int ID;
  String class_id;
  String material_name;
  String description;
  String material_type;
  String material_link;
  ClassMaterial({
    required this.ID,
    required this.class_id,
    required this.material_name,
    required this.description,
    required this.material_type,
    required this.material_link
  });
  factory ClassMaterial.fromJson(Map<String, dynamic> json){
    return ClassMaterial(
      ID: int.parse(json['id']),
      class_id: json['class_id'],
      material_name: json['material_name'],
      description: json['description'],
      material_type: json['material_type'],
      material_link: json['material_link'],
    );
  }
}