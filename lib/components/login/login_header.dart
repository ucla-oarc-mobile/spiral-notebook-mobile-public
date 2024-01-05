import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 12.0,
        ),
        Hero(
          tag: 'logo',
          child: Container(
            child: Image.asset(
              'images/logo/login-logo.png',
              semanticLabel: "Spiral Notebook",
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        )
      ],
    );
  }
}
