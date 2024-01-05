import 'package:flutter/material.dart';
import 'package:spiral_notebook/models/artifact/artifact.dart';
import 'package:spiral_notebook/models/shared_artifact/shared_artifact.dart';

class UniversalArtifactDetailsMetadata extends StatelessWidget {
  const UniversalArtifactDetailsMetadata({
    required this.universalArtifact,
    Key? key,
  }) : super(key: key);

  // This can be either an Artifact or a SharedArtifact.
  final dynamic universalArtifact;

  @override
  Widget build(BuildContext context) {

    RichText metadataRow({required String label, required String body}) {
      return RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(text: '$label: ' , style: TextStyle(fontWeight: FontWeight.bold)),
            (body.isNotEmpty && body != 'null')
                ? TextSpan(text: '$body', style: TextStyle(fontWeight: FontWeight.normal))
                : TextSpan(text: '(None provided)', style: TextStyle(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Artifact Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
                SizedBox(height: 12.0),
                if (universalArtifact is Artifact || universalArtifact is SharedArtifact)
                  metadataRow(label: 'Date Created', body: universalArtifact.formattedDateCreated),
                if (universalArtifact is Artifact || universalArtifact is SharedArtifact)
                  metadataRow(label: 'Last Edited', body: universalArtifact.formattedDateModified),
                if (universalArtifact is Artifact || universalArtifact is SharedArtifact)
                  metadataRow(label: 'Unit Timing', body: universalArtifact.unitTiming),
                if (universalArtifact is Artifact || universalArtifact is SharedArtifact)
                  metadataRow(label: 'Unit Day', body: universalArtifact.unitDay),
                if (universalArtifact is SharedArtifact)
                  metadataRow(label: 'Author', body: universalArtifact.displayName),
              ],
            ),
          ),
        ),
      ],
    );
  }
}