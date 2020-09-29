import 'dart:convert';
import 'dart:io';

import 'package:bybrisk_admin/beans/Employee.dart';
import 'package:bybrisk_admin/database/Constants.dart';
import 'package:bybrisk_admin/style/design.dart';
import 'package:bybrisk_admin/style/dimen.dart';
import 'package:bybrisk_admin/style/fonts.dart';
import 'package:bybrisk_admin/style/string.dart';
import 'package:bybrisk_admin/style/transaction.dart';
import 'package:bybrisk_admin/views/extra/deliveryPincode.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk_admin/style/colors.dart' as CustomColor;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Managers extends StatefulWidget {
  @override
  _ManagersState createState() => _ManagersState();
}

class _ManagersState extends State<Managers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var mListView = List<Employee>();
  bool isLoading = true;

  @override
  void initState() {
    this._fetchEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Delivery Boys",
          style: TextStyle(
              fontFamily: Bybriskfont().large,
              color: CustomColor.BybriskColor.primaryColor,
              fontSize: BybriskDimen().title),
        ),
      ),
      body: isLoading
          ? Center(
              child: SpinKitRipple(
                color: CustomColor.BybriskColor.primaryColor,
              ),
            )
          : RefreshIndicator(
              onRefresh: _refresh,
              child: Container(
                padding: EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                    itemCount: mListView.length,
                    itemBuilder: (BuildContext contex, int index) {
                      return _listViewContaintDesign(mListView[index]);
                    }),
              ),
            ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      mListView.clear();
      isLoading = true;
    });
    _fetchEmployees();
  }

  void _fetchEmployees() async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final response =
          await http.get(Constants().fetchEmployee, headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          mListView = (json.decode(response.body) as List)
              .map((data) => new Employee.fromJson(data))
              .toList();
          if (mListView.length > 0) {
            isLoading = false;
          } else {
            this._fetchEmployees();
            BybriskDesign()
                .showInSnackBar("Pincodes not added yet !", _scaffoldKey);
          }
        });
      }
    } on SocketException {
      BybriskDesign().showInSnackBar(
          "You are offline! check internet connection", _scaffoldKey);
      _fetchEmployees();
    }
  }

  Widget _listViewContaintDesign(Employee employee) {
    return InkWell(
      onTap: () {},
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(employee.name),
              subtitle: Text(employee.address),
              trailing: employee.status == 'ON'
                  ? Text("Activated")
                  : Text(("Pending")),
              onTap: () {
                if (employee.status == "ON") {
                  _onBottombar(employee);
                } else {
                  _offBottombar(employee);
                }
              },
            ),
            BybriskDesign().spacerBig()
          ],
        ),
      ),
    );
  }

  _offBottombar(Employee employee) {
    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (contex) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 18.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Employee Details",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Name",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 7.0),
                            child: Text(
                              employee.name,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 7.0),
                            child: Text(
                              employee.email,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Contact Number",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _makePhoneCall('tel:' + employee.mobile);
                            },
                            child: Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 7.0),
                              child: Text(
                                employee.mobile,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: Bybriskfont().large,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5.0),
                                    child: FlatButton(
                                      onPressed: () {
                                        _reject(employee.id);
                                      },
                                      child: Text(
                                        "REJECT",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: CustomColor
                                                .BybriskColor.primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5.0),
                                    child: FlatButton(
                                      onPressed: () {
                                        _accept(employee.id);
                                      },
                                      child: Text(
                                        "ACCEPT",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: CustomColor
                                                .BybriskColor.primaryColor),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 20.0,
                          )
                        ],
                      ),
                    ),
                  ));
            },
          );
        });
  }

  _onBottombar(Employee employee) {
    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (contex) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 18.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Employee Details",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Name",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 7.0),
                            child: Text(
                              employee.name,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 7.0),
                            child: Text(
                              employee.email,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().large,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Contact Number",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _makePhoneCall('tel:' + employee.mobile);
                            },
                            child: Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 7.0),
                              child: Text(
                                employee.mobile,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: Bybriskfont().large,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5.0),
                                    child: FlatButton(
                                      onPressed: () async {
                                        final result =
                                            await Navigator.of(context).push(
                                                FadeRouteBuilder(
                                                    page: deliveryPincode(
                                                        employee.id,
                                                        employee.pincodeList)));
                                        if (result != null) {
                                          if (result) {
                                            Navigator.of(context).pop();
                                            _refresh();
                                          }
                                        }
                                      },
                                      child: Text(
                                        "PINCODES",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: CustomColor
                                                .BybriskColor.primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 20.0,
                          )
                        ],
                      ),
                    ),
                  ));
            },
          );
        });
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch $url");
      throw 'Could not launch $url';
    }
  }

  void _accept(String id) async {
    String url = Constants().acceptEmployee;
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> jsondat = {"id": id, "status": "ON"};
    http.Response response =
        await http.post(url, headers: headers, body: json.encode(jsondat));
    var body = jsonDecode(response.body);
    if (!body['error']) {
      Navigator.of(context).pop();
      BybriskDesign().showInSnackBar("Confirmed successfully", _scaffoldKey);
      _refresh();
    } else {
      BybriskDesign()
          .showInSnackBar("Problem occurs ! Try again", _scaffoldKey);
      Navigator.of(context).pop();
    }
  }

  void _reject(String id) async {
    String url = Constants().rejectEmployee;
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> jsondat = {"id": id};
    http.Response response =
        await http.post(url, headers: headers, body: json.encode(jsondat));
    var body = jsonDecode(response.body);
    if (!body['error']) {
      Navigator.of(context).pop();
      BybriskDesign().showInSnackBar("Removes successfully", _scaffoldKey);
      _refresh();
    } else {
      BybriskDesign()
          .showInSnackBar("Problem occurs ! Try again", _scaffoldKey);
      Navigator.of(context).pop();
    }
  }
}
