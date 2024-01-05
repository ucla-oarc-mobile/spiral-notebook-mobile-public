import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class LoginEmailSingleText extends StatelessWidget {
  const LoginEmailSingleText({
    Key? key, required this.onChanged,
  }) : super(key: key);

  final ValueSetter<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofillHints: [AutofillHints.email],
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      autocorrect: false,
      enableSuggestions: false,
      textAlign: TextAlign.left,
      onChanged: this.onChanged,
      decoration: kTextFieldDecoration.copyWith(
        hintText: 'Enter Email',
      ),
    );
  }
}
