import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(
    this.label, {
    Key? key,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
        height: 1.57,
      ),
    );
  }
}
