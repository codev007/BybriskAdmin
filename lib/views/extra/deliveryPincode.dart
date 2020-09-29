import 'dart:convert';
import 'dart:io';
import 'package:bybrisk_admin/beans/Employee.dart';
import 'package:bybrisk_admin/beans/pincodes.dart';
import 'package:bybrisk_admin/database/Constants.dart';
import 'package:bybrisk_admin/style/design.dart';
import 'package:bybrisk_admin/style/dimen.dart';
import 'package:bybrisk_admin/style/fonts.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk_admin/style/colors.dart' as CustomColor;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class deliveryPincode extends StatefulWidget {
  final String mID;
  final List<PincodeList> pincodeList;
  deliveryPincode(this.mID, this.pincodeList, {Key key}) : super(key: key);

  @override
  _deliveryPincodeState createState() => _deliveryPincodeState();
}

class _deliveryPincodeState extends State<deliveryPincode> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var assignPincode = List<String>();
  bool isLoading = true;
  var mListView = List<Pincodes>();

  _pincodesGet() {
    for (int i = 0; i < widget.pincodeList.length; i++) {
      setState(() {
        assignPincode.add(widget.pincodeList[i].id.toString());
      });
    }

    _fetchPincodes();
  }

  @override
  void initState() {
    _pincodesGet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Associated Pincode",
          style: TextStyle(
              fontFamily: Bybriskfont().large,
              color: CustomColor.BybriskColor.primaryColor,
              fontSize: BybriskDimen().title),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.check_circle),
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                _update();
              })
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
                child: ListView.builder(
                  itemCount: mListView.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new CheckboxListTile(
                      title: new Text(
                        mListView[index].pincode,
                        style: TextStyle(
                            fontFamily: Bybriskfont().large,
                            color: CustomColor.BybriskColor.textPrimary,
                            fontSize: 20.0),
                      ),
                      onChanged: (bool value) {
                        setState(() {
                          if (value) {
                            assignPincode.add(mListView[index].id.toString());
                          } else {
                            assignPincode
                                .remove(mListView[index].id.toString());
                          }
                        });
                      },
                      value: assignPincode
                          .contains(mListView[index].id.toString()),
                    );
                  },
                ),
              ),
            ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      mListView.clear();
      isLoading = true;
    });
    _fetchPincodes();
  }

  void _fetchPincodes() async {
    try {
      Map<String, String> headers = {"Content-Type": "application/json"};
      final response =
          await http.get(Constants().fetchPincodes, headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          mListView = (json.decode(response.body) as List)
              .map((data) => new Pincodes.fromJson(data))
              .toList();
          if (mListView.length > 0) {
            isLoading = false;
          } else {
            //  this._fetchPincodes();
            BybriskDesign()
                .showInSnackBar("Pincodes not added yet !", _scaffoldKey);
          }
        });
      }
    } on SocketException {
      BybriskDesign().showInSnackBar(
          "You are offline! check internet connection", _scaffoldKey);
      _fetchPincodes();
    }
  }

  _update() async {
    try {
      String url = Constants().updatePincodeEmployee;
      Map<String, String> headers = {"Content-type": "application/json"};
      Map<String, dynamic> jsondat = {
        "id": widget.mID,
        "pincodes": assignPincode
      };
      http.Response response =
          await http.post(url, headers: headers, body: json.encode(jsondat));
      var body = jsonDecode(response.body);
      if (!body['error']) {
        Navigator.of(context).pop(true);
      } else {
        BybriskDesign()
            .showInSnackBar("Problem occurs ! Try again", _scaffoldKey);
      }
      setState(() {
        isLoading = false;
      });
    } on SocketException {
      BybriskDesign().showInSnackBar(
          "You are offline! check internet connection", _scaffoldKey);
      _fetchPincodes();
    }
  }
}
