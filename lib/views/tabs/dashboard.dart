import 'package:bybrisk_admin/style/transaction.dart';
import 'package:bybrisk_admin/views/details/managers.dart';
import 'package:bybrisk_admin/views/details/requests.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:bybrisk_admin/style/colors.dart' as CustomColor;
import 'package:bybrisk_admin/database/Constants.dart';
import 'package:bybrisk_admin/style/bybrisk_icons.dart';
import 'package:bybrisk_admin/style/design.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;
  String pending = "0";
  String picked = "0";
  String shipping = "0";
  String delivered = "0";
  void loadData() async {
    setState(() {
      isLoading = true;
    });
    try {
      String url = Constants().counts;
      Map<String, String> headers = {"Content-type": "application/json"};
      Map<String, dynamic> jsondat = {"id": "1"};
      http.Response response =
          await http.post(url, headers: headers, body: json.encode(jsondat));
      var body = jsonDecode(response.body);

      setState(() {
        pending = body['pending'].toString();
        picked = body['picked'].toString();
        shipping = body['shipping'].toString();
        delivered = body['delivered'].toString();
      });

      setState(() {
        isLoading = false;
      });
    } on SocketException {
      loadData();
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: isLoading
            ? Center(
                child: SpinKitRipple(
                  color: CustomColor.BybriskColor.primaryColor,
                ),
              )
            : RefreshIndicator(
                onRefresh: _refresh,
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: 20.0,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text("OVERVIEW".toUpperCase()),
                      ),
                      BybriskDesign().marginTopBottom(),
                      _dashBoard(),
                      BybriskDesign().marginTopBottom(),
                      BybriskDesign().spacerBig(),
                      BybriskDesign().marginTopBottom(),
                      Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text("Delivery Boy Management".toUpperCase()),
                      ),
                      BybriskDesign().marginTopBottom(),
                      _zoneManager(),
                      BybriskDesign().marginTopBottom(),
                      Container(
                        height: 60.0,
                      )
                    ],
                  ),
                ),
              ));
  }

  Future<void> _refresh() async {
    loadData();
  }

  _zoneManager() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Card(
                  elevation: 1.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(FadeRouteBuilder(page: Requests()));
                    },
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            decoration: BybriskDesign().cardDesign(),
                            padding: EdgeInsets.all(7.0),
                            child: Icon(
                              Icons.update,
                              size: 50.0,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "Pincode",
                                    style: BybriskDesign().mediumTextDesign(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
                Expanded(
                    child: Card(
                  elevation: 1.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(FadeRouteBuilder(page: Managers()));
                    },
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            decoration: BybriskDesign().cardDesign(),
                            padding: EdgeInsets.all(7.0),
                            child: Icon(
                              Icons.group,
                              size: 50.0,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "Delivery Boys",
                                    style: BybriskDesign().mediumTextDesign(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _dashBoard() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Card(
                  elevation: 1.0,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: BybriskDesign().cardDesign(),
                          padding: EdgeInsets.all(7.0),
                          //  color: CustomColor.BybriskColor.primaryColor,
                          child: Icon(
                            Bybrisk.deliver,
                            size: 50.0,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0, top: 7.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "Pending",
                                  style: BybriskDesign().mediumTextDesign(),
                                ),
                              ),
                              Container(
                                child: Text(
                                  pending,
                                  style: BybriskDesign().largeTextDesign(),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
                Expanded(
                    child: Card(
                  elevation: 1.0,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: BybriskDesign().cardDesign(),
                          padding: EdgeInsets.all(7.0),
                          child: Icon(
                            Bybrisk.help,
                            size: 50.0,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0, top: 7.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "Picked",
                                  style: BybriskDesign().mediumTextDesign(),
                                ),
                              ),
                              Container(
                                child: Text(
                                  picked,
                                  style: BybriskDesign().largeTextDesign(),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Card(
                  elevation: 1.0,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: BybriskDesign().cardDesign(),
                          padding: EdgeInsets.all(7.0),
                          child: Icon(
                            Bybrisk.shipment,
                            size: 50.0,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0, top: 7.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "Shipping",
                                  style: BybriskDesign().mediumTextDesign(),
                                ),
                              ),
                              Container(
                                child: Text(
                                  shipping,
                                  style: BybriskDesign().largeTextDesign(),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
                Expanded(
                    child: Card(
                  elevation: 1.0,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: BybriskDesign().cardDesign(),
                          padding: EdgeInsets.all(7.0),
                          child: Icon(
                            Bybrisk.truck,
                            size: 50.0,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0, top: 7.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "Delivered",
                                  style: BybriskDesign().mediumTextDesign(),
                                ),
                              ),
                              Container(
                                child: Text(
                                  delivered,
                                  style: BybriskDesign().largeTextDesign(),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
