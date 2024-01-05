import 'package:flutter/material.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class ArtifactDetailsBonusHeader extends StatelessWidget {
  const ArtifactDetailsBonusHeader({
    Key? key, required this.label,
  }) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FractionallySizedBox(
          widthFactor: 1,
          child: Container(
            color: buttonBGDisabledGrey,
            padding: const EdgeInsets.all(8.0),
            child: Text('Team Question'),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 18.0,bottom: 12.0),
          child: Text(label,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}