import 'package:flutter/material.dart';

class ArtifactDetailsResponseText extends StatelessWidget {
  const ArtifactDetailsResponseText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}