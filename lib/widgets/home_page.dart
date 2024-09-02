// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:flutter/material.dart';

import 'components/build_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Future _addProduct(context) {
  //   return showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(25),
  //         topRight: Radius.circular(25),
  //       ),
  //     ),
  //     builder: (context) {
  //       return SingleChildScrollView(
  //           padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).viewInsets.bottom),
  //           child: AddProduct(title: 'Add Product',));
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-commerce Admin'),
        centerTitle: true,
      ),
      drawer: BuildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/carts");
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return CartScreen(title: 'Cart',);
                  //     },
                  //   ),
                  // );
                },
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.purple),
                ),
                child: Text("CartSceen"))
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _addProduct(context);
      //   },
      //   tooltip: "Add Product",
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
