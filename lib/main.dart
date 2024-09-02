import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/cart_notifier.dart';
import 'controllers/category_notifier.dart';
import 'controllers/product_notifier.dart';
import 'controllers/supply_notifier.dart';
import 'controllers/user_notifier.dart';
import 'controllers/vendor_notifier.dart';
import 'models/category.dart';
import 'models/product.dart';
import 'models/supply.dart';
import 'models/user.dart';
import 'models/vendor.dart';
import 'services/request.dart';
import 'widgets/components/cart_screen.dart';
import 'widgets/components/category_view.dart';
import 'widgets/components/product_view.dart';
import 'widgets/components/supply_view.dart';
import 'widgets/components/user_view.dart';
import 'widgets/components/vendor_view.dart';
import 'widgets/forms/add_category.dart';
import 'widgets/forms/add_product.dart';
import 'widgets/forms/add_supply.dart';
import 'widgets/forms/add_user.dart';
import 'widgets/forms/add_vendor.dart';
import 'widgets/home_page.dart';

void main() async {
  var categoryResponse = await get('admin/all-categories');
  List<Category> categoryList = [];
  List<dynamic> categoryData = categoryResponse.data;
  for (var category in categoryData) {
    categoryList.add(Category.fromMap(category));
  }

  var productResponse = await get('admin/products');
  List<Product> productList = [];
  List<dynamic> productData = productResponse.data;
  for (var product in productData) {
    productList.add(Product.fromMap(product));
  }

  var userResponse = await get('admin/users');
  List<User> userList = [];
  List<dynamic> userData = userResponse.data;
  for (var user in userData) {
    userList.add(User.fromMap(user));
  }

  var vendorResponse = await get('admin/vendors');
  List<Vendor> vendorList = [];
  List<dynamic> vendorData = vendorResponse.data;
  for (var vendor in vendorData) {
    vendorList.add(Vendor.fromMap(vendor));
  }

  var supplyResponse = await get('admin/supplies');
  List<Supply> supplyList = [];
  List<dynamic> supplyData = supplyResponse.data;
  for (var supply in supplyData) {
    supplyList.add(Supply.fromMap(supply));
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductNotifier.all(productList),
        ),
        ChangeNotifierProvider(
          create: (context) => CartNotifier(),
        ),
        ChangeNotifierProvider<CategoryNotifier>(
          create: (context) => CategoryNotifier.all(categoryList),
        ),
        ChangeNotifierProvider<UserNotifier>(
          create: (context) => UserNotifier.all(userList),
        ),
        ChangeNotifierProvider<VendorNotifier>(
          create: (context) => VendorNotifier.all(vendorList),
        ),
        ChangeNotifierProvider<SupplyNotifier>(
          create: (context) => SupplyNotifier.all(supplyList),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
      routes: {
        "/add-product": (context) {
          return const AddProduct(
            title: 'Add Product',
          );
        },
        "/add-category": (context) {
          return const AddCategory(
            title: 'Add Category',
          );
        },
        "/add-user": (context) {
          return const AddUser(
            title: 'Add User',
          );
        },
        "/add-vendor": (context) {
          return const AddVendor(
            title: 'Add Vendor',
          );
        },
        "/add-supply": (context) {
          return const AddSupply(
            title: 'Add Supply',
          );
        },
        "/carts": (context) {
          return const CartScreen(
            title: 'Cart',
          );
        },
        "/products": (context) {
          return const ProductView(
            title: 'All Products',
          );
        },
        "/categories": (context) {
          return const CategoryView(
            title: 'All Categories',
          );
        },
        "/users": (context) {
          return const UserView(
            title: 'All Users',
          );
        },
        "/vendors": (context) {
          return const VendorView(
            title: 'All Vendors',
          );
        },
        "/supplies": (context) {
          return const SupplyView(
            title: 'All Vendors',
          );
        },
       
      },
    );
  }
}
