import 'package:flutter/material.dart';

class InlineSectionText extends StatelessWidget {
  const InlineSectionText({
    Key? key, required this.label,
  }) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 0.0),
      child: Text(label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14.0,
        ),
      ),
    );
  }
}