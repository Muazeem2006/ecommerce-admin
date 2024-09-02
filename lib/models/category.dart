// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Category {
  String name;
  String description;
  int? parentId;
  int? id;
  String? icon;

  Category({
     this.id,
    required this.name,
    required this.description,
    this.parentId,
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'parent_id': parentId,
      'description': description,
      'icon': icon,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'] as String,
      parentId: map['parent_id'],
      description: map['description'] as String,
      icon: map['icon'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);
}
