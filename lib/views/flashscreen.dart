import 'dart:async';
import 'package:bybrisk_admin/database/sharedPreferences.dart';
import 'package:bybrisk_admin/style/icons.dart';
import 'package:bybrisk_admin/style/transaction.dart';
import 'package:bybrisk_admin/views/HomeScreen.dart';
import 'package:bybrisk_admin/views/login.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk_admin/style/colors.dart' as CustomColors;

class FlashScreen extends StatefulWidget {
  @override
  _FlashScreenState createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  bool isLogin;

  _data() async {
    bool log = await SharedDatabase().isLogin();
    setState(() {
      isLogin = log;
    });

    if (isLogin != null) {
      if (isLogin) {
        Timer(
            Duration(seconds: 2),
            () => Navigator.of(context)
                .pushReplacement(FadeRouteBuilder(page: Home())));
      } else {
        Timer(
            Duration(seconds: 2),
            () => Navigator.of(context)
                .pushReplacement(FadeRouteBuilder(page: LogIn())));
      }
    } else {
      Timer(
          Duration(seconds: 2),
          () => Navigator.of(context)
              .pushReplacement(FadeRouteBuilder(page: LogIn())));
    }
  }

  @override
  void initState() {
    this._data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              height: 100.0,
              child: Image.asset(
                BybriskIcon().logo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
