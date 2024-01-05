import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/parking_lot/parking_lot_artifacts_empty.dart';
import 'package:spiral_notebook/models/artifact/artifact.dart';
import 'package:spiral_notebook/models/artifact/artifacts.dart';
import 'package:spiral_notebook/providers/artifacts_provider.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:spiral_notebook/screens/parking_lot_screen.dart';
import 'package:spiral_notebook/components/common/parking_lot_icon.dart';
import 'package:spiral_notebook/components/common/inline_section_header.dart';

final filteredArtifactsProvider = Provider<List<Artifact>>((ref) {
  final Artifacts artifacts = ref.watch(artifactsProvider);
  return artifacts.artifacts.where((artifact) => artifact.inParkingLot).toList();
});

class DashboardParkingLotSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Artifact> artifacts = ref.watch(filteredArtifactsProvider);


    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Divider(thickness: 2.0,),
        ),
        InlineSectionHeader(label: 'Parking Lot'),
        (artifacts.isEmpty)
            ? ParkingLotArtifactsListEmpty()
            : Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, ParkingLotScreen.id),
            style: ElevatedButton.styleFrom(
              elevation: 0.0, backgroundColor: Colors.white,
              side: BorderSide(width: 1.0, color: primaryButtonBlue),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  ParkingLotIcon(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text('Complete Parking Lot Artifacts', style: TextStyle(color: primaryButtonBlue)),
                    ),
                  ),
                  Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      color: primaryButtonBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('${artifacts.length}', style: TextStyle(color: Colors.white)),
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
