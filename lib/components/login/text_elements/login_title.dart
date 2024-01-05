import 'package:flutter/material.dart';

class LoginTitle extends StatelessWidget {
  const LoginTitle(
    this.label, {
    Key? key,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28.0,
        height: 1.54,
      ),
    );
  }
}
