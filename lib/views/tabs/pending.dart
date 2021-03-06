import 'dart:convert';
import 'dart:io';
import 'package:bybrisk_admin/style/colors.dart' as CustomColor;
import 'package:bybrisk_admin/beans/Overview.dart';
import 'package:bybrisk_admin/database/Constants.dart';
import 'package:bybrisk_admin/style/design.dart';
import 'package:bybrisk_admin/style/fonts.dart';
import 'package:bybrisk_admin/style/transaction.dart';
import 'package:bybrisk_admin/views/delivery/pending.dart';
import 'package:bybrisk_admin/views/delivery/picked.dart';
import 'package:bybrisk_admin/views/details/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Pending extends StatefulWidget {
  const Pending({Key key}) : super(key: key);
  @override
  _PendingState createState() => _PendingState();
}

class _PendingState extends State<Pending> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var deliveriesList = List<Overview>();
  bool isLoading = true;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    this._fetchDeliveries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                padding: EdgeInsets.only(top: 10.0),
                child: ListView.builder(
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

  _listViewContaintDesign(Overview overview) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            FadeRouteBuilder(page: PendingDeliveriesDetails(overview.pincode)));
      },
      child: Container(
        padding:
            EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                overview.pincode + "( " + overview.number.toString() + " )",
                style: TextStyle(
                    fontFamily: Bybriskfont().large,
                    color: CustomColor.BybriskColor.textPrimary,
                    fontSize: 20.0),
              ),
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
      final response =
          await http.get(Constants().pendingOverview, headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          deliveriesList = (json.decode(response.body) as List)
              .map((data) => new Overview.fromJson(data))
              .toList();
          if (deliveriesList.length > 0) {
            isLoading = false;
          } else {
            this._fetchDeliveries();
            BybriskDesign()
                .showInSnackBar("Pincodes not added yet !", _scaffoldKey);
          }
        });
      }
    } on SocketException {
      BybriskDesign().showInSnackBar(
          "You are offline! check internet connection", _scaffoldKey);
      _fetchDeliveries();
    }
  }
}
