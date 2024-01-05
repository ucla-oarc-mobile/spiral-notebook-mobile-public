import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    this.myColor = Colors.blue,
    this.myText = '',
    this.myOnPressed,
  });

  final Color myColor;
  final String myText;
  final void Function()? myOnPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
      child: Material(
        elevation: 0.0,
        color: myColor,
        borderRadius: BorderRadius.circular(2.0),
        child: MaterialButton(
          onPressed: myOnPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            myText,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
