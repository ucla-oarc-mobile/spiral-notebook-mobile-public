import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/login/buttons/login_back_to_login.dart';
import 'package:spiral_notebook/components/login/fields/login_email_single_text.dart';
import 'package:spiral_notebook/components/login/text_elements/login_field_label.dart';
import 'package:spiral_notebook/components/login/buttons/login_submit_button.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({
    Key? key,
  }) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FieldLabel('Email'),
          SizedBox(height: 10.0),
          LoginEmailSingleText(
            onChanged: (value) {
              this.email = value;
            },
          ),
          SizedBox(height: 36.0),
          LoginSubmitButton(myText: 'SUBMIT', myOnPressed: this.submitCallback),
          SizedBox(height: 8.0),
          BackToLogin(),
        ],
      ),
    );
  }

  void validateLoginForm() {
    // throw exceptions if there are issues with the form's data.
    if (email.isEmpty)
      throw FormatException('Please enter your user email address.');

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email);
    if (!emailValid)
      throw FormatException('Please enter a valid email address.');
  }

  void submitCallback() async {
    bool validatePassed = true;

    try {
      validateLoginForm();
    } catch (e) {
      String message = (e is FormatException)
          ? e.message
          : "Error submitting form, please try again.";
      showSnackAlert(context, message);
      validatePassed = false;
    }

    if (validatePassed) {
      // This should send an email with change password instructions.
    }
  }
}
