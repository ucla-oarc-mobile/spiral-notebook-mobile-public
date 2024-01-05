import 'package:flutter/material.dart';

class ContactInfoElement extends StatelessWidget {
  const ContactInfoElement(
    this.label,
    this.value, {
    Key? key,
  }) : super(key: key);

  final String label;

  final String value;

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SelectableText.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text: this.label + ':',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        height: 1.43)),
                TextSpan(text: ' ' + this.value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
