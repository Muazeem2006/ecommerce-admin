// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, library_private_types_in_public_api, depend_on_referenced_packages

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin/models/vendor.dart';

import '../../controllers/vendor_notifier.dart';
import '../../services/request.dart';

class AddVendor extends StatefulWidget {
  final String title;
  const AddVendor({Key? key, required this.title}) : super(key: key);

  @override
  _AddVendorState createState() => _AddVendorState();
}

class _AddVendorState extends State<AddVendor> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _image;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
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
            Padding(
              padding: EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
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
                    _image != null
                        ? Center(
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
                        : Center(child: Text('No image selected')),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _saveVendor();
                          }
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                            Size(double.infinity, 50),
                          ),
                        ),
                        child: Text('Submit'),
                      ),
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

  void _saveVendor() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final address = _addressController.text.trim();
    final phone = _phoneController.text.trim();
    final vendor = Vendor(
      name: name,
      email: email,
      address: address,
      phone: phone,
    );
    saveVendor(vendor, context);
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

  // Saving vendor to the server
  Future<void> saveVendor(Vendor vendor, BuildContext context) async {
    try {
      // Show a loading indicator while saving a vendor
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
      FormData formData = FormData.fromMap(vendor.toMap());
      formData.files
          .add(MapEntry('image', MultipartFile.fromFileSync(_image!.path)));
      final response = await post('admin/add-vendor', formData);
      if (response.data['success'] != null) {
        vendor = Vendor.fromMap(response.data['success']);
        context.read<VendorNotifier>().addVendor(vendor);
        Navigator.pushReplacementNamed(context, '/vendors');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Saving Failed'),
            content: Text(
                'An error occurred while saving the vendor. Please try again.'),
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
}
