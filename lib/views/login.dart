import 'dart:async';
import 'dart:convert';
import 'package:bybrisk_admin/database/Constants.dart';
import 'package:bybrisk_admin/database/sharedPreferences.dart';
import 'package:bybrisk_admin/style/design.dart';
import 'package:bybrisk_admin/style/dimen.dart';
import 'package:bybrisk_admin/style/fonts.dart';
import 'package:bybrisk_admin/style/string.dart';
import 'package:bybrisk_admin/style/transaction.dart';
import 'package:bybrisk_admin/views/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk_admin/style/colors.dart' as CustomColor;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool isLoading = false;
  bool isSuccess = false;
  String username;
  String password;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: null,
      floatingActionButton: isLoading
          ? Container()
          : FloatingActionButton.extended(
              label: Text("Login"),
              onPressed: () {
                if (username.length > 0 && password.length > 0) {
                  setState(() {
                    isLoading = true;
                  });
                  sendLoginRequest(username, password);
                }
              },
              icon: Icon(Icons.arrow_forward),
            ),
      body: isLoading
          ? Center(
              child: SpinKitRipple(
                color: CustomColor.BybriskColor.primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 60.0, left: 10.0, right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Hello, \nAdmin\nPlease Login",
                        style: TextStyle(
                            fontFamily: Bybriskfont().large,
                            color: CustomColor.BybriskColor.primaryColor,
                            fontSize: BybriskDimen().exlarge),
                      ),
                    ),
                    Container(
                      height: 40.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 2.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "username".toUpperCase(),
                        style: TextStyle(fontSize: BybriskDimen().exsmall),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: TextFormField(
                        autofocus: false,
                        //  controller: password,
                        obscureText: false,
                        onChanged: (value) {
                          if (value.length > 0) {
                            setState(() {
                              username = value.toString();
                            });
                          }
                        },
                        //   validator: Validate().validatePassword,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Username ',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 2.0, top: 10.0),
                      child: Text(
                        "password".toUpperCase(),
                        style: TextStyle(fontSize: BybriskDimen().exsmall),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: TextFormField(
                        autofocus: false,
                        //  controller: password,
                        obscureText: true,
                        onChanged: (value) {
                          if (value.length > 0) {
                            setState(() {
                              password = value.toString();
                            });
                          }
                        },
                        //   validator: Validate().validatePassword,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Password',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      height: 30.0,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  sendLoginRequest(String username, String password) async {
    String url = Constants().login;
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> jsondat = {"username": username, "password": password};
    http.Response response =
        await http.post(url, headers: headers, body: json.encode(jsondat));
    var body = jsonDecode(response.body);
    if (!body['error']) {
      SharedDatabase().setLogin(true);
      Navigator.of(context).pushReplacement(FadeRouteBuilder(page: Home()));
    } else {
      SharedDatabase().setLogin(false);
      showInSnackBar("Something went wrong ! Try again...");
    }

    setState(() {
      isLoading = false;
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(value),
        duration: Duration(milliseconds: 1000),
      ),
    );
  }

}
