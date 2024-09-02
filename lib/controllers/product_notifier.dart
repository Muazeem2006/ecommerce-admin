import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductNotifier extends ChangeNotifier {
  List<Product> productList = [];

  // adding product
  addProduct(Product product) {
    productList.add(product);
    notifyListeners();
  }

  // deleting product
  deleteProduct(Product product) {
    productList.remove(product);
    notifyListeners();
  }

  // loading product from the database into provider
  ProductNotifier.all(List<Product> products) {
    productList = products;
    notifyListeners();
  }
}
