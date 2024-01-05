import 'package:flutter/material.dart';

class ArtifactDetailsInlineNotice extends StatelessWidget {
  const ArtifactDetailsInlineNotice({
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
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}