// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/user_notifier.dart';

class UserView extends StatelessWidget {
  final String title;
  const UserView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userNotifier = Provider.of<UserNotifier>(context);
    final userList = userNotifier.userList;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
            if (userList.isEmpty)
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
              Consumer<UserNotifier>(
                builder: (context, userNotifier, child) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: userList.length,
                    itemBuilder: (BuildContext context, i) {
                      final user = userList[i];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text((user.firstName)[0].toUpperCase()),
                        ),
                        title: Text(user.name),
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
                                  WidgetSpan(child: Text(user.email)),
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
                                    child: Text(user.address),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: "Gender:",
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
                                    child: Text(user.gender),
                                  ),
                                  WidgetSpan(
                                    child: SizedBox(
                                      width: 10,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: Text(
                                      "Age:",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: SizedBox(
                                      width: 5,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: Text(
                                      "${user.age} years",
                                    ),
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
