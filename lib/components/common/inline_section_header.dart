import 'package:flutter/material.dart';

class InlineSectionHeader extends StatelessWidget {
  const InlineSectionHeader({
    Key? key, required this.label,
  }) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 0.0),
      child: Text(label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }
}