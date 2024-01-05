import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

import '../../rounded_button.dart';

class LoginSubmitButton extends StatelessWidget {
  const LoginSubmitButton(
      {Key? key, required this.myOnPressed, required this.myText})
      : super(key: key);

  final VoidCallback? myOnPressed;
  final String myText;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      myColor: primaryButtonBlue,
      myText: this.myText.toUpperCase(),
      myOnPressed: this.myOnPressed,
    );
  }
}
