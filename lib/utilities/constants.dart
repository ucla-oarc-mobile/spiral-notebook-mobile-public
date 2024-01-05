import 'package:flutter/material.dart';


const primaryButtonBlue = Color.fromARGB(255, 39, 116, 174);
const interfaceButtonBlue = Color.fromARGB(255, 91, 135, 187);
const buttonBorderGrey = Color.fromARGB(255, 176, 176, 176);

const buttonDisabledGrey = Color.fromARGB(255, 101, 101, 101);

const buttonBGDisabledGrey = Color.fromARGB(255, 238, 238, 238);

const defaultNetworkTimeout = Duration(seconds: 6);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: buttonBorderGrey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: buttonBorderGrey, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);

const EdgeInsetsGeometry artifactsListOuterPaddingLeft = EdgeInsets.only(left: 16.0);
const EdgeInsetsGeometry artifactsListInteriorPadding = EdgeInsets.symmetric(horizontal: 8.0);
const EdgeInsetsGeometry artifactsListOuterPaddingRight = EdgeInsets.only(right: 16.0);
const EdgeInsetsGeometry artifactsListRowPadding = EdgeInsets.symmetric(vertical: 8.0);

const TextStyle artifactsListHeaderStyle = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.bold,
);
const TextStyle artifactsListNameColumnStyle = TextStyle(
  fontWeight: FontWeight.bold,
);
const TextStyle artifactsListDateColumnStyle = TextStyle();