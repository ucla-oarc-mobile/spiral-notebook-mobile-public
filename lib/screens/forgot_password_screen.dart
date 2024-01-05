import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/login/forms/forgot_password_form.dart';
import 'package:spiral_notebook/components/login/login_header.dart';
import 'package:spiral_notebook/components/login/login_footer.dart';

// TODO: Remove Forgot Password screen from app.


class ForgotPasswordScreen extends StatefulWidget {
  static String id = 'forgot_password_screen';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 38.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  LoginHeader(),
                  Text(
                    'Enter your email address and we will send you instructions on how to create a new password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  ForgotPasswordForm(),
                  SizedBox(height: 111.0),
                  LoginFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
