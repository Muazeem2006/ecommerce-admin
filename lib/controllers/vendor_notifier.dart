import 'package:flutter/material.dart';
import '../models/vendor.dart';

class VendorNotifier extends ChangeNotifier {
  List<Vendor> vendorList = [];

  // adding vendor
  addVendor(Vendor vendor) {
    vendorList.add(vendor);
    notifyListeners();
  }

  // deleting vendor
  deleteVendor(Vendor vendor) {
    vendorList.remove(vendor);
    notifyListeners();
  }

  // loading vendor from the database into provider
  VendorNotifier.all(List<Vendor> vendors) {
    vendorList = vendors;
    notifyListeners();
  }
}
