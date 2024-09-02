// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin/models/supply.dart';

import '../../controllers/product_notifier.dart';
import '../../controllers/supply_notifier.dart';
import '../../controllers/vendor_notifier.dart';
import '../../models/product.dart';
import '../../models/vendor.dart';
import '../../services/request.dart';

class AddSupply extends StatefulWidget {
  final String title;
  const AddSupply({Key? key, required this.title}) : super(key: key);

  @override
  _AddSupplyState createState() => _AddSupplyState();
}

class _AddSupplyState extends State<AddSupply> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _suppliedDateController = TextEditingController();
  Product? _selectedProduct;
  Vendor? _selectedVendor;
  @override
  void dispose() {
    _quantityController.dispose();
    _suppliedDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productNotifier = Provider.of<ProductNotifier>(context);
    final productList = productNotifier.productList;
    final vendorNotifier = Provider.of<VendorNotifier>(context);
    final vendorList = vendorNotifier.vendorList;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Consumer<ProductNotifier>(
                      builder: (context, productNotifier, child) {
                        return Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          child: PopupMenuButton<Product>(
                            onSelected: (Product value) {
                              setState(() {
                                _selectedProduct = value;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return productList.map((Product product) {
                                return PopupMenuItem<Product>(
                                  value: product,
                                  child: Text(product.name),
                                );
                              }).toList();
                            },
                            child: ListTile(
                              title: Text(
                                  _selectedProduct?.name ?? 'Select a product'),
                              trailing: Icon(Icons.arrow_drop_down),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Consumer<VendorNotifier>(
                      builder: (context, vendorNotifier, child) {
                        return Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Vendor>(
                              value: _selectedVendor,
                              hint: Text(
                                'Select a vendor',
                                style: TextStyle(color: Colors.purple),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _selectedVendor = value!;
                                });
                              },
                              items: vendorList.map((Vendor vendor) {
                                return DropdownMenuItem(
                                  value: vendor,
                                  child: Text(vendor.name),
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
                    TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveSupply();
                        }
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(double.infinity, 50),
                        ),
                      ),
                      child: Text('Submit'),
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

  void _saveSupply() {
    final quantity = _quantityController.text.trim();
    final supply = Supply(
      product: _selectedProduct!,
      vendor: _selectedVendor!,
      quantity: int.parse(quantity),
    );
    saveSupply(supply, context);
  }

  Future<void> saveSupply(Supply supply, BuildContext context) async {
    try {
      // Show a loading indicator while saving a supply
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

      final response = await post('admin/add-supply', supply.toMap());
      if (response.data['success'] != null) {
        supply = Supply.fromMap(response.data['success']);
        // print('data = $supply');
        context.read<SupplyNotifier>().addSupply(supply);
        Navigator.pushReplacementNamed(context, '/supplies');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Saving Failed'),
            content: Text(
                'An error occurred while saving the supply. Please try again.'),
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
