import 'dart:convert';
import 'dart:io';
import 'package:bybrisk_admin/beans/Delivery.dart';
import 'package:bybrisk_admin/database/Constants.dart';
import 'package:bybrisk_admin/style/design.dart';
import 'package:bybrisk_admin/style/dimen.dart';
import 'package:bybrisk_admin/style/fonts.dart';
import 'package:bybrisk_admin/style/string.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk_admin/style/colors.dart' as CustomColor;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PickedDeliveries extends StatefulWidget {
  final String mPincode;
  PickedDeliveries(this.mPincode, {Key key}) : super(key: key);
  @override
  _PickedDeliveriesState createState() => _PickedDeliveriesState();
}

class _PickedDeliveriesState extends State<PickedDeliveries> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = true;
  var deliveriesList = List<Delivery>();
  bool isUpdate = false;
  var selected = List<String>();
  @override
  void initState() {
    this._fetchDeliveries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.mPincode,
          style: TextStyle(
              fontFamily: Bybriskfont().large,
              color: CustomColor.BybriskColor.primaryColor,
              fontSize: BybriskDimen().title),
        ),
        actions: <Widget>[
          isUpdate
              ? IconButton(
                  icon: Icon(Icons.check_circle),
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    this._submit();
                  },
                )
              : FlatButton(
                  onPressed: () {
                    setState(() {
                      isUpdate = true;
                    });
                  },
                  child: Text("UPDATE TO SHIPPING")),
          isUpdate
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      selected.clear();
                      isUpdate = false;
                    });
                  })
              : Container()
        ],
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
                child: isUpdate
                    ? ListView.builder(
                        itemCount: deliveriesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new CheckboxListTile(
                            title: new Text(
                              deliveriesList[index].orderId,
                              style: TextStyle(
                                  fontFamily: Bybriskfont().large,
                                  color: CustomColor.BybriskColor.textPrimary,
                                  fontSize: 20.0),
                            ),
                            onChanged: (bool value) {
                              setState(() {
                                if (value) {
                                  selected.add(deliveriesList[index].id);
                                } else {
                                  selected.remove(deliveriesList[index].id);
                                }
                              });
                            },
                            value: selected.contains(deliveriesList[index].id),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: deliveriesList.length,
                        itemBuilder: (BuildContext contex, int index) {
                          return _listViewContaintDesign(deliveriesList[index]);
                        }),
              ),
            ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      deliveriesList.clear();
      isLoading = true;
    });
    _fetchDeliveries();
  }

  _listViewContaintDesign(Delivery delivery) {
    return InkWell(
      onTap: () {
        _deliveryDetails(delivery);
      },
      child: Container(
        padding:
            EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                delivery.orderId,
                style: TextStyle(
                    fontFamily: Bybriskfont().large,
                    color: CustomColor.BybriskColor.textPrimary,
                    fontSize: 20.0),
              ),
            ),
            Container(
              child: Text("From : " + delivery.businessName),
            ),
            Divider()
          ],
        ),
      ),
    );
  }

  _fetchDeliveries() async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      Map<String, dynamic> jsondat = {"pincode": widget.mPincode};

      final response = await http.post(Constants().pickedDeliveries,
          headers: headers, body: json.encode(jsondat));
      if (response.statusCode == 200) {
        setState(() {
          deliveriesList = (json.decode(response.body) as List)
              .map((data) => new Delivery.fromJson(data))
              .toList();
          if (deliveriesList.length > 0) {
            isLoading = false;
          } else {
            this._fetchDeliveries();
            BybriskDesign().showInSnackBar("Delivery not found", _scaffoldKey);
          }
        });
      }
    } on SocketException {
      BybriskDesign().showInSnackBar(
          "You are offline! check internet connection", _scaffoldKey);
      _fetchDeliveries();
    }
  }

  _deliveryDetails(Delivery deliveryPojo) {
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
                              "Delivery Details",
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
                              "Destination Address",
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
                              deliveryPojo.address,
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
                              "Destination Pincode",
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
                              deliveryPojo.pincode,
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
                              _makePhoneCall('tel:' + deliveryPojo.mobile);
                            },
                            child: Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 7.0),
                              child: Text(
                                deliveryPojo.mobile,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: Bybriskfont().large,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Business Contact Number",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _makePhoneCall(
                                  'tel:' + deliveryPojo.bmobile.toString());
                            },
                            child: Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 7.0),
                              child: Text(
                                deliveryPojo.bmobile,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontFamily: Bybriskfont().large,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: 5.0, left: 10.0, right: 10.0),
                            child: Text(
                              "Delivery Type",
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
                              deliveryPojo.cOD == "PP"
                                  ? "Prepaid"
                                  : "Cash on delivery : ₹" + deliveryPojo.cOD,
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
                              "Delivery Status",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().small,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 7.0),
                            child: Text(
                              deliveryPojo.status == "1"
                                  ? "Pending"
                                  : deliveryPojo.status == "2"
                                      ? "Picked"
                                      : deliveryPojo.status == "3"
                                          ? "Shipping"
                                          : deliveryPojo.status == "5"
                                              ? "Out for delivery"
                                              : "Delivered",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: Bybriskfont().large,
                              ),
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

  void _submit() async {
    try {
      Map<String, dynamic> jsondat = {"ids": selected};
      print(jsondat.toString());
      Map<String, String> headers = {"Content-Type": "application/json"};
      http.Response response = await http.post(Constants().pickedTpShipping,
          headers: headers, body: json.encode(jsondat));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        if (!body['error']) {

          BybriskDesign()
              .showInSnackBar("Updated successfully !", _scaffoldKey);
          setState(() {
            selected.clear();
            isUpdate = false;
          });
          _refresh();
        } else {
          BybriskDesign()
              .showInSnackBar("Something wrong ! Try again", _scaffoldKey);
        }
        setState(() {
          isLoading = false;
        });
      }
    } on SocketException {
      BybriskDesign().showInSnackBar(
          "You are offline! check internet connection", _scaffoldKey);
      _fetchDeliveries();
    }
  }
}
