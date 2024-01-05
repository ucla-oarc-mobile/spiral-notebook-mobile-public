import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spiral_notebook/providers/multi_providers_manager.dart';
import 'package:spiral_notebook/screens/home_tabs_frame.dart';
import 'package:spiral_notebook/services/auth_service.dart';
import 'package:spiral_notebook/utilities/loading.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';
import 'package:spiral_notebook/components/login/fields/login_email_single_text.dart';
import 'package:spiral_notebook/components/login/text_elements/login_field_label.dart';
import 'package:spiral_notebook/components/login/buttons/login_forgot_password.dart';
import 'package:spiral_notebook/components/login/fields/login_password_single_text.dart';
import 'package:spiral_notebook/components/login/buttons/login_submit_button.dart';
import 'package:spiral_notebook/components/login/text_elements/login_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final AuthService _auth = AuthService();

  String username = '';
  String password = '';

  void validateLoginForm() {
    // throw exceptions if there are issues with the form's data.
    if (username.isEmpty)
      throw FormatException('Please enter your user email address.');

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(username);
    if (!emailValid)
      throw FormatException('Please enter a valid email address.');
    if (password.isEmpty) throw FormatException('Please enter your password.');
  }

  void submitCallback() async {

    bool validatePassed = true;

    try {
      validateLoginForm();
    } catch (e) {
      String message = (e is FormatException)
          ? e.message
          : "Error validating form, please try again.";
      showSnackAlert(context, message);
      validatePassed = false;
    }

    if (validatePassed) {
      try {
        showLoading(context, 'Logging in...');
        final loginResponseBundle = await _auth.authorizedViaPassword(
          username: username,
          password: password,
        );

        if (loginResponseBundle == null) {
          throw FormatException(
              'Unable to login, please review and try again.');
        }

        final MultiProviderManager multiProviderManager = MultiProviderManager(ref);

        multiProviderManager.bootstrapAll(loginResponseBundle);

        dismissLoading(context);

        Navigator.pushNamedAndRemoveUntil(
            context, HomeTabsFrame.id, (Route<dynamic> route) => false);
      } catch (e) {
        dismissLoading(context);
        String message = (e is HttpException)
            ? e.message
            : "Error submitting form, please try again.";

        if (e is TimeoutException) {
          message = 'Bad network connection, please try again later.';
        }
        showSnackAlert(context, message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AutofillGroup(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginTitle(
              'Login',
            ),
            SizedBox(
              height: 20.0,
            ),
            FieldLabel('Email'),
            SizedBox(height: 10.0),
            LoginEmailSingleText(onChanged: (value) {
              this.username = value;
            }),
            SizedBox(height: 20.0),
            FieldLabel('Password'),
            SizedBox(height: 10.0),
            LoginPasswordSingleText(onChanged: (value) {
              this.password = value;
            }),
            SizedBox(height: 36.0),
            LoginSubmitButton(myText: 'LOGIN', myOnPressed: submitCallback),
            SizedBox(height: 8.0),
            LoginForgotPassword(),
          ],
        ),
      ),
    );
  }
}
