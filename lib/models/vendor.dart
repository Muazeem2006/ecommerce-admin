import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Vendor {
  int? id;
  String name;
  String email;
  String address;
  String phone;
  String? image;
  Vendor({
    this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
      'image': image,
    };
  }

  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Vendor.fromJson(String source) =>
      Vendor.fromMap(json.decode(source) as Map<String, dynamic>);
}
