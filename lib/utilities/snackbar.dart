import 'package:flutter/material.dart';

void showSnackAlert(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    duration: const Duration(seconds: 3),
  ));
}