// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_is_empty, unrelated_type_equality_checks, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/product_notifier.dart';

class ProductView extends StatefulWidget {
  final String title;
  const ProductView({Key? key, required this.title}) : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    final productNotifier = Provider.of<ProductNotifier>(context);
    final productList = productNotifier.productList;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Chip(
              label: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 16,
                ),
              ),
            ),
            if (productList.isEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/no-data.png',
                    fit: BoxFit.contain,
                    width: 200,
                    height: 200,
                  ),
                  Text(
                    "No Data!!!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: "Times New Roman"),
                  ),
                  Text(
                    "Check your network connection and try again!",
                  ),
                ],
              )
            else
              Consumer<ProductNotifier>(
                builder: (context, productNotifier, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: productNotifier.productList.length,
                    itemBuilder: (context, i) {
                      final product = productNotifier.productList[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          child: Icon(Icons.abc),
                        ),
                        isThreeLine: true,
                        title: Text(product.name),
                        subtitle: Text(
                            "${product.description}\nBrand: ${product.brand}"),
                        style: ListTileStyle.drawer,
                      );
                    },
                  );
                },
              )
          ],
        ),
      ),
    );
  }
}
