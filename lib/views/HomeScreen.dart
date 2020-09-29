import 'package:bybrisk_admin/style/colors.dart' as CustomColor;
import 'package:bybrisk_admin/style/dimen.dart';
import 'package:bybrisk_admin/style/fonts.dart';
import 'package:bybrisk_admin/style/string.dart';
import 'package:bybrisk_admin/style/transaction.dart';
import 'package:bybrisk_admin/views/details/managers.dart';
import 'package:bybrisk_admin/views/tabs/dashboard.dart';
import 'package:bybrisk_admin/views/tabs/delivered.dart';
import 'package:bybrisk_admin/views/tabs/outfordeliver.dart';
import 'package:bybrisk_admin/views/tabs/pending.dart';
import 'package:bybrisk_admin/views/tabs/picked.dart';
import 'package:bybrisk_admin/views/tabs/shipping.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _messageText = "Waiting for message...";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    _firebaseMessaging.subscribeToTopic("admin");
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print(_messageText);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print(_messageText);
      },
    );

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        print('$token');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: DefaultTabController(
            length: 6,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                bottom: TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(
                      text: "DASHBOARD",
                    ),
                    Tab(
                      text: "PENDING DELIVERIES",
                    ),
                    Tab(
                      text: "PICKED DELIVERIES",
                    ),
                    Tab(
                      text: "SHIPPING DELIVERIES",
                    ),
                    Tab(
                      text: "OUT FOR DELIVER",
                    ),
                    Tab(
                      text: "DELIVERED HISTORY",
                    ),
                  ],
                ),
                title: Text(
                  BybrickString().appName,
                  style: TextStyle(
                      fontFamily: Bybriskfont().large,
                      color: CustomColor.BybriskColor.primaryColor,
                      fontSize: BybriskDimen().title),
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  Dashboard(
                    key: PageStorageKey("p1"),
                  ),
                  Pending(
                    key: PageStorageKey("p2"),
                  ),
                  Picked(
                    key: PageStorageKey("p3"),
                  ),
                  Shipping(
                    key: PageStorageKey("p4"),
                  ),
                  OutForDeliver(
                    key: PageStorageKey("p5"),
                  ),
                  Delivered(
                    key: PageStorageKey("p6"),
                  )
                ],
              ),
            )));
  }
}
