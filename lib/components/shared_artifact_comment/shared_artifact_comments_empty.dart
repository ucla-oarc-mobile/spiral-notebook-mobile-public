import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/common/inline_section_text.dart';

class SharedArtifactCommentsEmpty extends StatelessWidget {
  const SharedArtifactCommentsEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: InlineSectionText(label: 'No Comments for this Shared Artifact.'),
    );
  }
}