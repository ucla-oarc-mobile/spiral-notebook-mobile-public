import 'package:flutter/material.dart';
import 'package:spiral_notebook/screens/login_screen.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class BackToLogin extends StatelessWidget {
  const BackToLogin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.popUntil(context, (route) {
          return route.settings.name == LoginScreen.id;
        });
      },
      child: Text(
        'BACK TO LOGIN',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: primaryButtonBlue,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
