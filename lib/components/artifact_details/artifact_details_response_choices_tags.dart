import 'package:flutter/material.dart';

class ArtifactDetailsTagChoices extends StatelessWidget {
  const ArtifactDetailsTagChoices({
    Key? key,
    required this.tags,
  }) : super(key: key);

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children:
      tags.map((text) =>
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(text, style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                )),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.black, width: 1.0),
              ),
            ),
          ),
      ).toList(),
    );
  }
}