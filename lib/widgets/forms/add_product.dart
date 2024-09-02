// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_null_comparison, depend_on_referenced_packages, avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce_admin/models/category.dart';
import 'package:ecommerce_admin/services/request.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../controllers/category_notifier.dart';
import '../../controllers/product_notifier.dart';
import '../../models/product.dart';

class AddProduct extends StatefulWidget {
  final String title;
  const AddProduct({Key? key, required this.title}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _productKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  Category? _category;

  // Image selection
  File? _image;

  void _saveProduct() {
    final name = _nameController.text.trim();
    final brand = _brandController.text.trim();
    final description = _descriptionController.text.trim();
    final price = _priceController.text.trim();
    final product = Product(
      name: name,
      brand: brand,
      description: description,
      price: price,
      categoryId: _category?.id,
    );
    saveProduct(product, context);
  }

  // Sending to the server
  Future<void> saveProduct(Product product, BuildContext context) async {
    try {
      // Show a loading indicator while saving a product
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      //request to the server
      FormData formData = FormData.fromMap(product.toMap());
      formData.files
          .add(MapEntry('image', MultipartFile.fromFileSync(_image!.path)));
      print("file + $formData.files}");
      final response = await post('admin/add-product', formData);
      if (response.data['success'] != null) {
        product = Product.fromMap(response.data['success']);
        print('product $product');
        context.read<ProductNotifier>().addProduct(product);
        Navigator.pushReplacementNamed(context, '/products');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Saving Failed'),
            content: Text(
                'An error occurred while saving the product. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle network or server error
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'An error occurred. Please check your internet connection and try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _image == null;
    _category!.name == '';
    super.dispose();
  }

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
          children: [
            Form(
              key: _productKey,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      style: TextStyle(color: Colors.purple),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: Text("Name"),
                        labelStyle: TextStyle(color: Colors.purple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _brandController,
                      style: TextStyle(color: Colors.purple),
                      decoration: InputDecoration(
                        label: Text("Brand"),
                        labelStyle: TextStyle(color: Colors.purple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      controller: _descriptionController,
                      style: TextStyle(color: Colors.purple),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: Text("Description"),
                        labelStyle: TextStyle(color: Colors.purple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Consumer<CategoryNotifier>(
                      builder: (context, categoryNotifier, child) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Category>(
                              value: _category,
                              hint: Text(
                                'Select Category',
                                style: TextStyle(color: Colors.purple),
                              ),
                              isExpanded: true,
                              onChanged: (Category? value) {
                                setState(() {
                                  _category = value!;
                                });
                              },
                              items: categoryList.map((Category category) {
                                return DropdownMenuItem<Category>(
                                  value: category,
                                  child: Text(
                                    category.name,
                                    style: TextStyle(color: Colors.purple),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _priceController,
                      style: TextStyle(color: Colors.purple),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: Text("Price"),
                        labelStyle: TextStyle(color: Colors.purple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            _takePicture();
                          },
                          child: Chip(
                            label: Text("From Camera"),
                            avatar: CircleAvatar(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _selectPicture();
                          },
                          child: Chip(
                            label: Text("From Gallery"),
                            avatar: CircleAvatar(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              child: Icon(
                                Icons.collections,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    if (_image != null)
                      Card(
                        elevation: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _image!,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Center(child: Text('No image selected')),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_productKey.currentState!.validate()) {
                          _saveProduct();
                        }
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(double.infinity, 50),
                        ),
                      ),
                      child: Text('Add Product'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Snap image with camera
  Future<void> _takePicture() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageFile == null) {
      return;
    }
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = File('${appDir.path}/$fileName');
    await savedImage.writeAsBytes(await imageFile.readAsBytes());
    setState(() {
      _image = savedImage;
    });
  }

  // Select from gallery
  Future<void> _selectPicture() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      return;
    }
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = File('${appDir.path}/$fileName');
    await savedImage.writeAsBytes(await imageFile.readAsBytes());
    setState(() {
      _image = savedImage;
    });
  }
}
