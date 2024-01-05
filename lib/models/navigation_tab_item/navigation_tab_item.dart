import 'package:flutter/material.dart';

class NavigationTabItem {
  final String appBarTitle;
  final Widget destinationWidget;
  final Icon icon;
  final Function()? onSelect;
  // called only if the onSelect operation fails.
  final Function()? onSelectFail;

  NavigationTabItem({
    required this.appBarTitle,
    required this.destinationWidget,
    required this.icon,
    this.onSelect,
    this.onSelectFail,
  });
}