// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../models/product.dart';

class CartNotifier extends ChangeNotifier {
  Cart _cart = Cart(id: 1, products: {});

  Cart get cart => _cart;

  // adding product
  void addToCart(Product product) {
    if (_cart.products.containsKey(product)) {
      _cart.products[product] = _cart.products[product]! + 1; // increase quantity
    } else {
      _cart.products[product] = 1; // add new product with quantity of 1
    }
    notifyListeners();
  }

  // deleting product
  void removeFromCart(Product product) {
    if (_cart.products.containsKey(product)) {
      _cart.products.remove(product); // remove product from cart
      notifyListeners();
    }
  }

  // increase quantity of product in cart
  void increaseQuantity(Product product) {
    if (_cart.products.containsKey(product)) {
      _cart.products[product] = _cart.products[product]! + 1; // increase quantity
      notifyListeners();
    }
  }

  // decrease quantity of product in cart
  void decreaseQuantity(Product product) {
    if (_cart.products.containsKey(product)) {
      if (_cart.products[product]! > 1) {
        _cart.products[product] = _cart.products[product]! - 1; // decrease quantity
      } else {
        _cart.products.remove(product); // remove product from cart if quantity is 1
      }
      notifyListeners();
    }
  }
}