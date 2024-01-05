import 'package:flutter/material.dart';

class ArtifactDataHeader extends StatelessWidget {
  const ArtifactDataHeader({
    Key? key, required this.label,
  }) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 18.0,bottom: 12.0),
      child: Text(label,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.0,
        ),
      ),
    );
  }
}