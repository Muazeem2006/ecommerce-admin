// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_notifier.dart';

class CartScreen extends StatelessWidget {
  final String title;
  const CartScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartNotifier = Provider.of<CartNotifier>(context);
    final cart = cartNotifier.cart;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<CartNotifier>(
              builder: (context, cartNotifier, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cart.products.length,
                    itemBuilder: (context, i) {
                      final entry = cart.products.entries.elementAt(i);
                      final product = entry.key;
                      final quantity = entry.value;
                      return Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.maxFinite,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(product.image!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                                "\$${(product.price)}"),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            RatingBar.builder(
                                              initialRating: 3,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 12,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                debugPrint("$rating");
                                              },
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  cartNotifier.increaseQuantity(
                                                      product);
                                                },
                                                child: Icon(Icons.add)),
                                            Text('$quantity'),
                                            InkWell(
                                              onTap: () {
                                                cartNotifier
                                                    .decreaseQuantity(product);
                                              },
                                              child: Icon(Icons.remove),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "${product.name} removed from cart"),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        cartNotifier.removeFromCart(product);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.purple,
                                          border: Border.all(
                                            style: BorderStyle.solid,
                                            width: 2.0,
                                            color: Colors.purple,
                                          ),
                                        ),
                                        child: Text(
                                          "Remove from cart",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 20.0,
                      mainAxisExtent: 270,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text.rich(
                    TextSpan(
                      text: "Total: ",
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                      children: <InlineSpan>[
                        WidgetSpan(
                          child: Text(
                            "\$${(cart.total).toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Checkout >>",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
