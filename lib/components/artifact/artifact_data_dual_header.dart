import 'package:flutter/material.dart';

// data header with two parts: main heading and sub heading.

class ArtifactDataDualHeader extends StatelessWidget {
  const ArtifactDataDualHeader({
    Key? key,
    required this.mainHead,
    required this.subHead,
  }) : super(key: key);
  final String mainHead;
  final String subHead;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 18.0,bottom: 12.0),
      child: Row(
        children: [
          Text(mainHead,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          SizedBox(width: 4.0),
          Text(subHead,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}