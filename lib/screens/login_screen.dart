import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/login/forms/login_form.dart';
import 'package:spiral_notebook/components/login/login_header.dart';
import 'package:spiral_notebook/components/login/login_footer.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 38.0),
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  // enable dismissing keyboard by tapping outside input field.
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    LoginHeader(),
                    LoginForm(),
                    SizedBox(height: 35.0),
                    LoginFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
