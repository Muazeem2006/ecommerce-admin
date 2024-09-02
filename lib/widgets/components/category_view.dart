// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_is_empty, unrelated_type_equality_checks, library_private_types_in_public_api

import 'package:ecommerce_admin/controllers/category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryView extends StatefulWidget {
  final String title;
  const CategoryView({Key? key, required this.title}) : super(key: key);

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  Widget build(BuildContext context) {
    final categoryNotifier = Provider.of<CategoryNotifier>(context);
    final categoryList = categoryNotifier.categoryList;
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
            if (categoryList.isEmpty)
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
              Consumer<CategoryNotifier>(
                builder: (context, categoryNotifier, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: categoryNotifier.categoryList.length,
                    itemBuilder: (context, i) {
                      final category = categoryNotifier.categoryList[i];
                      return ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            child: Icon(Icons.abc)),
                        title: Text(category.name),
                        subtitle: Text(category.description),
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
