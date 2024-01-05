import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginForgotPassword extends StatelessWidget {
  const LoginForgotPassword({
    Key? key,
  }) : super(key: key);

  void goForgotPasswordWeb() async {
    // give feedback
    String forgotPasswordUrl = 'https://spiralproject.org/forgot-password';

    if (!await launchUrl(Uri.parse(forgotPasswordUrl))) throw 'Could not launch $forgotPasswordUrl';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        goForgotPasswordWeb();
      },
      child: Semantics(
        link: true,
        child: Text(
          'Forgot Password?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: primaryButtonBlue,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}
