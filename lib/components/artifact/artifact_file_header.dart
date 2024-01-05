import 'package:flutter/material.dart';

class ArtifactFileHeader extends StatelessWidget {
  const ArtifactFileHeader({
    Key? key, required this.label,
  }) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 18.0,bottom: 12.0),
      child: Text(label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    );
  }
}