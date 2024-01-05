import 'package:flutter/material.dart';

class ArtifactDetailsListChoices extends StatelessWidget {
  const ArtifactDetailsListChoices({
    Key? key,
    required this.choices,
  }) : super(key: key);

  final List<String> choices;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      choices.map((text) =>
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.fiber_manual_record_rounded, size: 8.0,),
                SizedBox(width:4.0),
                Flexible(
                  child: Text(text, style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                  )),
                ),
              ],
            ),
          ),
      ).toList(),
    );
  }
}