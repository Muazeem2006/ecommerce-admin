import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class Product {
  String name;
  String? brand;
  String description;
  int? categoryId;
  int? id;
  String price;
  String? image;
  int? quantity;
  Product({
    required this.name,
    this.brand,
    required this.description,
    required this.categoryId,
    this.id,
    required this.price,
    this.image,
    this.quantity = 1,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'brand': brand,
      'description': description,
      'category_id': categoryId,
      'id': id,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      brand: map['brand'] != null ? map['brand'] as String : null,
      description: map['description'] as String,
      categoryId: map['category_id'] != null ? map['category_id'] as int : null,
      id: map['id'] != null ? map['id'] as int : null,
      price: map['price'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      quantity: map['quantity'] != null ? (map['quantity'] is int ? map['quantity']: int.tryParse(map['quantity']) ) : null,

    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
