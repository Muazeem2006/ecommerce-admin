// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'product.dart';
import 'vendor.dart';

class Supply {
  int? id;
  Product product;
  Vendor vendor;
  int? quantity;
  DateTime? date;
  Supply({
    DateTime? date,
    this.id,
    required this.product,
    required this.vendor,
    this.quantity = 1,
  }) : date = date ?? DateTime.now();

  double get totalAmount {
    if (quantity != null) {
      double price = double.tryParse(product.price) ?? 0.0;
      return price * quantity!;
    }
    return 0.0;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product': product.toMap(),
      'vendor': vendor.toMap(),
      'quantity': quantity,
      'date': date?.toIso8601String(),
    };
  }

  factory Supply.fromMap(Map<String, dynamic> map) {
    return Supply(
      id: map['id'] != null ? map['id'] as int : null,
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      vendor: Vendor.fromMap(map['vendor'] as Map<String, dynamic>),
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      date: map['date'] != null
          ? DateTime.parse(map['date'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Supply.fromJson(String source) =>
      Supply.fromMap(json.decode(source) as Map<String, dynamic>);
}
