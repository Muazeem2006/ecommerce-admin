// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';
import 'package:dio/dio.dart';
import '/controllers/category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_admin/models/category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:ecommerce_admin/services/request.dart';
import 'package:provider/provider.dart';

class AddCategory extends StatefulWidget {
  final String title;
  const AddCategory({Key? key, required this.title}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _categoryKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _parentController = TextEditingController();
  File? _imageURL;
  Category? _category;

  //To save data with model to the database
  void _saveCategory() {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final category = Category(
      name: name,
      parentId: _category?.id,
      description: description,
    );
    saveCategory(category, context);
  }

  // Sending to the server
  Future<void> saveCategory(Category category, BuildContext context) async {
    try {
      // Show a loading indicator while saving a category
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
      FormData formData = FormData.fromMap(category.toMap());
      formData.files
          .add(MapEntry('icon', MultipartFile.fromFileSync(_imageURL!.path)));
      final response = await post('admin/add-category', formData);
      if (response.data['success'] != null) {
        category = Category.fromMap(response.data['success']);
        context.read<CategoryNotifier>().addCategory(category);
        Navigator.pushReplacementNamed(context, '/categories');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Saving Failed'),
            content: Text(
                'An error occurred while saving the category. Please try again.'),
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
    _descriptionController.dispose();
    _parentController.dispose();
    _imageURL == null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _categoryKey,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.purple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a category name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(color: Colors.purple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Consumer<CategoryNotifier>(
                      builder: (context, categoryNotifer, child) {
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
                                'Select Parent Category',
                                style: TextStyle(color: Colors.purple),
                              ),
                              isExpanded: true,
                              onChanged: (Category? value) {
                                setState(() {
                                  _category = value!;
                                });
                              },
                              items: categoryNotifer.categoryList
                                  .map((Category category) {
                                return DropdownMenuItem<Category>(
                                  value: category,
                                  child: Text(category.name),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.0),
                    ListTile(
                      title: Text('Upload Image'),
                      subtitle: Row(
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
                    ),
                    SizedBox(height: 5.0),
                    _imageURL != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _imageURL!,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(child: Text('No image selected')),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_categoryKey.currentState!.validate()) {
                          _saveCategory();
                        }
                      },
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                            Size(double.infinity, 50),
                          ),
                        ),
                      child: Text('Add Catory'),
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

  //To capture image with camera
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
      _imageURL = savedImage;
    });
  }

  //To capture image from gallery
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
      _imageURL = savedImage;
    });
  }
}
