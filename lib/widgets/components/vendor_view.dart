// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/vendor_notifier.dart';

class VendorView extends StatelessWidget {
  final String title;
  const VendorView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vendorNotifier = Provider.of<VendorNotifier>(context);
    final vendorList = vendorNotifier.vendorList;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (vendorList.isEmpty)
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/no-data.png',
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "No Data!!!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Check your network connection and try again!",
                    ),
                  ],
                ),
              )
            else
              Consumer<VendorNotifier>(
                builder: (context, vendorNotifier, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: vendorList.length,
                    itemBuilder: (BuildContext context, i) {
                      final vendor = vendorList[i];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text((vendor.name)[0].toUpperCase()),
                        ),
                        title: Text(vendor.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "Email:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                children: <InlineSpan>[
                                  WidgetSpan(
                                    child: SizedBox(
                                      width: 5,
                                    ),
                                  ),
                                  WidgetSpan(child: Text(vendor.email)),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: "Address",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                children: <InlineSpan>[
                                  WidgetSpan(
                                    child: SizedBox(
                                      width: 5,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: Text(vendor.address),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: "Phone Number",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                children: <InlineSpan>[
                                  WidgetSpan(
                                    child: SizedBox(
                                      width: 5,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: Text(vendor.phone),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
