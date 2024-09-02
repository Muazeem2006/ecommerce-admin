// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class BuildDrawer extends StatelessWidget {
  const BuildDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("E-commerce Admin"),
            accountEmail: Text("admin@ecommerce.com"),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff0b63f6),
                  Color(0xff003cc5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange,
              foregroundColor: Color(0xff003cc5),
              child: Text(
                "A",
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                // your other list tiles
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text('Cart'),
                  onTap: () {
                    Navigator.pushNamed(context, '/carts');
                  },
                ),
                ExpansionTile(
                  leading: Icon(Icons.category),
                  title: Text('Category'),
                  children: [
                    ListTile(
                      title: Text('Add Category'),
                      onTap: () {
                        Navigator.pushNamed(context, '/add-category');
                      },
                    ),
                    ListTile(
                      title: Text('Category View'),
                      onTap: () {
                        Navigator.pushNamed(context, '/categories');
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Icon(Icons.inventory),
                  title: Text('Product'),
                  children: [
                    ListTile(
                      title: Text('Add Product'),
                      onTap: () {
                        Navigator.pushNamed(context, '/add-product');
                      },
                    ),
                    ListTile(
                      title: Text('Product View'),
                      onTap: () {
                        Navigator.pushNamed(context, '/products');
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Icon(Icons.person_2_rounded),
                  title: Text('User'),
                  children: [
                    ListTile(
                      title: Text('Add User'),
                      onTap: () {
                        Navigator.pushNamed(context, '/add-user');
                      },
                    ),
                    ListTile(
                      title: Text('User View'),
                      onTap: () {
                        Navigator.pushNamed(context, '/users');
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Icon(Icons.person_4_rounded),
                  title: Text('Vendor'),
                  children: [
                    ListTile(
                      title: Text('Add Vendor'),
                      onTap: () {
                        Navigator.pushNamed(context, '/add-vendor');
                      },
                    ),
                    ListTile(
                      title: Text('Vendor View'),
                      onTap: () {
                        Navigator.pushNamed(context, '/vendors');
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Icon(Icons.local_shipping),
                  title: Text('Supplies'),
                  children: [
                    ListTile(
                      title: Text('Add Supply'),
                      onTap: () {
                        Navigator.pushNamed(context, '/add-supply');
                      },
                    ),
                    ListTile(
                      title: Text('Supply View'),
                      onTap: () {
                        Navigator.pushNamed(context, '/supplies');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
