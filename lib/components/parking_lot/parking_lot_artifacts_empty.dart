import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/common/inline_section_text.dart';

class ParkingLotArtifactsListEmpty extends StatelessWidget {
  const ParkingLotArtifactsListEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: InlineSectionText(label: 'No Artifacts in the Parking Lot.'),
    );
  }
}