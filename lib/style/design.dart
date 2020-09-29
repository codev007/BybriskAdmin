import 'package:bybrisk_admin/style/colors.dart' as CustomColor;
import 'package:bybrisk_admin/style/dimen.dart';
import 'package:bybrisk_admin/style/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BybriskDesign {
  hollowButtonDesign() {
    return BoxDecoration(
        color: CustomColor.BybriskColor.primaryColor,
        border: Border.all(width: 1, color: CustomColor.BybriskColor.white),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ));
  }

  dropdownDesign() {
    return BoxDecoration(
        color: Colors.black12,
        //     border: Border.all(width: 1, color: CustomColor.BybriskColor.primaryColor),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ));
  }

  hollowsubmitDesign() {
    return BoxDecoration(
        //     color: CustomColor.BybriskColor.white,
        border: Border.all(
            width: 0.25, color: CustomColor.BybriskColor.primaryColor),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ));
  }


  cardDesign() {
    return BoxDecoration(
        color: CustomColor.BybriskColor.primaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),bottomRight: Radius.circular(20.0)
        ));
  }

  spacer() {
    return Container(
      height: 1.0,
      color: CustomColor.BybriskColor.textSecondary,
    );
  }
  spacerBig() {
    return Container(
      height: 6.0,
      color: CustomColor.BybriskColor.textField,
    );
  }
  largeTextDesign() {
    return TextStyle(
        fontFamily: Bybriskfont().large,
        color: CustomColor.BybriskColor.textSecondary,
        fontSize: BybriskDimen().exlarge
    );
  }

  mediumTextDesign() {
    return TextStyle(
        fontFamily: Bybriskfont().large,
        color: CustomColor.BybriskColor.primaryColor,
        fontSize: BybriskDimen().small);
  }

  smallTextDesign() {
    return TextStyle();
  }

  exsmallTextDesign() {
    return TextStyle();
  }

  titleTextDesign() {
    return TextStyle(
        fontFamily: Bybriskfont().large,
        color: CustomColor.BybriskColor.textPrimary,
        fontSize: BybriskDimen().title);
  }

  marginTopBottom(){
    return Container(
      height: 10.0,
    );
  }
  void showInSnackBar(String value, GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(value),
        duration: Duration(milliseconds: 1000),
      ),
    );
  }
}
