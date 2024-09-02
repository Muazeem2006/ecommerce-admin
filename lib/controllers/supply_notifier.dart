import 'package:flutter/material.dart';
import '../models/supply.dart';

class SupplyNotifier extends ChangeNotifier {
  List<Supply> supplyList = [];

  // adding supply
  addSupply(Supply supply) {
    supplyList.add(supply);
    notifyListeners();
  }

  // deleting supply
  deleteSupply(Supply supply) {
    supplyList.remove(supply);
    notifyListeners();
  }

  // loading supply from the database into provider
  SupplyNotifier.all(List<Supply> supplys) {
    supplyList = supplys;
    notifyListeners();
  }
}
