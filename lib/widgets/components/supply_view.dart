// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/supply_notifier.dart';

class SupplyView extends StatelessWidget {
  final String title;
  const SupplyView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supplyNotifier = Provider.of<SupplyNotifier>(context);
    final supplyList = supplyNotifier.supplyList;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              print('clicked');
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (supplyList.isEmpty)
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
              Consumer<SupplyNotifier>(
                builder: (context, supplyNotifier, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: supplyList.length,
                    itemBuilder: (BuildContext context, i) {
                      final supply = supplyList[i];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.local_shipping),
                        ),
                        title: Text.rich(
                          TextSpan(
                            text: "Product:",
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
                                child: Text(supply.product.name),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: "Unit cost:",
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
                                        child: Text(supply.product.price),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: "Total cost:",
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
                                        child: Text((supply.totalAmount)
                                            .toStringAsFixed(2)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: "Vendor:",
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
                                        child: Text(supply.vendor.name),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: "Date:",
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
                                        child: Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(supply.date!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Text.rich(
                              TextSpan(
                                text: "Quantity:",
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
                                    child: Text("${supply.quantity} qty"),
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
