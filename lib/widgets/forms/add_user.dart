// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, avoid_print, depend_on_referenced_packages, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin/models/user.dart';

import '../../controllers/user_notifier.dart';
import '../../services/request.dart';

class AddUser extends StatefulWidget {
  final String title;
  const AddUser({Key? key, required this.title}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _gender;
  DateTime? _dob;
  File? _image;

  

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
      });
    }
  }

  void _saveUser() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final address = _addressController.text.trim();
    final password = _passwordController.text.trim();
    final phone = _phoneController.text.trim();
    final gender = _gender!.trim();
    final dob = DateTime.parse(_dob!.toIso8601String());
    final user = User(
      firstName: firstName,
      lastName: lastName,
      email: email,
      address: address,
      password: password,
      phone: phone,
      gender: gender,
      dob: dob,
    );
    saveUser(user, context);
  }

  // Sending to the server
  Future<void> saveUser(User user, BuildContext context) async {
    try {
      // Show a loading indicator while saving a user
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
      FormData formData = FormData.fromMap(user.toMap());
      formData.files
          .add(MapEntry('image', MultipartFile.fromFileSync(_image!.path)));

      final response = await post('admin/add-user', formData);
      if (response.data['success'] != null) {
        print("response ${response.data['success']}");
        user = User.fromMap(response.data['success']);
        print("user $user");
        context.read<UserNotifier>().addUser(user);
        Navigator.pushReplacementNamed(context, '/users');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Saving Failed'),
            content: Text(
                'An error occurred while saving the user. Please try again.'),
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

  List<Widget> _buildGenderListTiles() {
    return ['Male', 'Female'].map((gender) {
      return Expanded(
        child: RadioListTile(
          title: Text(gender),
          value: gender,
          groupValue: _gender,
          onChanged: (value) {
            setState(() {
              _gender = value;
            });
          },
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
              CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? Image.asset('images/profile.png')
                            : null,
                      ),
                  Positioned(
                    right: -5,
                    bottom: 0,
                    child: PopupMenuButton(
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'camera',
                          child: Text('Camera'),
                        ),
                        PopupMenuItem(
                          value: 'gallery',
                          child: Text('Gallery'),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'camera') {
                          _takePicture();
                        } else if (value == 'gallery') {
                          _selectPicture();
                        }
                      },
                      icon: CircleAvatar(child: Icon(Icons.camera_alt)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        autofocus: true,
                        controller: _firstNameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(color: Colors.purple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _lastNameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: TextStyle(color: Colors.purple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.purple),
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
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _addressController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          labelStyle: TextStyle(color: Colors.purple),
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
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.purple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }

                          return null;
                        },
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _phoneController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          labelStyle: TextStyle(color: Colors.purple),
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
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: _buildGenderListTiles(),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ListTile(
                        title: Text('Date of Birth'),
                        subtitle: Text(
                          _dob == null
                              ? 'Please select a date'
                              : 'Selected Date: ${_dob.toString().substring(0, 10)}',
                        ),
                        onTap: () => _selectDate(context),
                        trailing: Icon(Icons.calendar_today),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _gender != null &&
                              _dob != null) {
                            _saveUser();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Please select your gender and date of birth'),
                            ));
                          }
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                            Size(double.infinity, 50),
                          ),
                        ),
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
