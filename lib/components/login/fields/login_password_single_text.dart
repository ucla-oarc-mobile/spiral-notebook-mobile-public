import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class LoginPasswordSingleText extends StatelessWidget {
  const LoginPasswordSingleText({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  final ValueSetter<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofillHints: [AutofillHints.password],
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
      obscureText: true,
      textAlign: TextAlign.left,
      onChanged: this.onChanged,
      decoration: kTextFieldDecoration.copyWith(
        hintText: 'Enter Password',
      ),
    );
  }
}
