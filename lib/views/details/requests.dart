import 'dart:convert';
import 'dart:io';
import 'package:bybrisk_admin/beans/Employee.dart';
import 'package:bybrisk_admin/beans/pincodes.dart';
import 'package:bybrisk_admin/database/Constants.dart';
import 'package:bybrisk_admin/style/design.dart';
import 'package:bybrisk_admin/style/dimen.dart';
import 'package:bybrisk_admin/style/fonts.dart';
import 'package:bybrisk_admin/style/string.dart';
import 'package:flutter/material.dart';
import 'package:bybrisk_admin/style/colors.dart' as CustomColor;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class Requests extends StatefulWidget {
  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var mListView = List<Pincodes>();
  bool isLoading = true;
  var uuid = new Uuid();
  String _pincode;
  bool isAdding = false;

  @override
  void initState() {
    this._fetchEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pincode",
          style: TextStyle(
              fontFamily: Bybriskfont().large,
              color: CustomColor.BybriskColor.primaryColor,
              fontSize: BybriskDimen().title),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                this.smsCodeDialog(context);
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
          await http.get(Constants().fetchPincodes, headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          mListView = (json.decode(response.body) as List)
              .map((data) => new Pincodes.fromJson(data))
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

  Widget _listViewContaintDesign(Pincodes pincodes) {
    return InkWell(
      onTap: () {},
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
              child: Text(
                pincodes.pincode,
                style: TextStyle(
                    fontFamily: Bybriskfont().large,
                    color: CustomColor.BybriskColor.textPrimary,
                    fontSize: 20.0),
              ),
            ),
            BybriskDesign().spacerBig()
          ],
        ),
      ),
    );
  }

  _addPincode(String pincode) async {
    String url = Constants().addPincode;
    Map<String, String> headers = {"Content-type": "application/json"};
    Map<String, dynamic> jsondat = {"pincode": pincode};
    http.Response response =
        await http.post(url, headers: headers, body: json.encode(jsondat));
    var body = jsonDecode(response.body);
    if (!body['error']) {
      Navigator.of(context).pop();
      _refresh();
    } else {
      BybriskDesign().showInSnackBar("Something missing !", _scaffoldKey);
    }

    setState(() {
      isLoading = false;
    });
  }

  smsCodeDialog(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setBottomState) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(5.0),
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  tooltip: "Close",
                                  padding: EdgeInsets.only(bottom: 5.0),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setBottomState(() {
                                      isAdding = false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: CustomColor.BybriskColor.primaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(19.0),
                                topRight: Radius.circular(19.0)),
                          )),
                      isAdding
                          ? Container(
                              margin: EdgeInsets.all(50.0),
                              child: Center(child: CircularProgressIndicator()))
                          : Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(15.0),
                                    child: Text(
                                      "Please enter pincode",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                    ),
                                    child: TextField(
                                      minLines: 1,
                                      maxLines: 1,
                                      autofocus: false,
                                      maxLength: 6,
                                      obscureText: false,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        if (value.length > 0) {
                                          setBottomState(() {
                                            this._pincode = value;
                                          });
                                        } else {}
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        hintText: 'Enter 6 digit pincode',
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 2.0, 20.0, 2.0),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(15.0),
                                    alignment: Alignment.center,
                                    child: RaisedButton(
                                      onPressed: () {
                                        if (_pincode.length == 6) {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());

                                          setBottomState(() {
                                            isAdding = true;
                                          });

                                          _addPincode(_pincode);
                                        } else {
                                          BybriskDesign().showInSnackBar(
                                              "Invalide pincode !",
                                              _scaffoldKey);
                                        }
                                      },
                                      color:
                                          CustomColor.BybriskColor.primaryColor,
                                      child: Text(
                                        "ADD PINCODE",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
