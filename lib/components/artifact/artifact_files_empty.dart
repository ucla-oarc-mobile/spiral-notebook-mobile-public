import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/common/inline_section_text.dart';

class ArtifactFilesEmpty extends StatelessWidget {
  const ArtifactFilesEmpty({
    Key? key,
    required this.typeLabel,
  }) : super(key: key);

  final String typeLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: InlineSectionText(label: 'No ${typeLabel}s Selected.'),
    );
  }
}