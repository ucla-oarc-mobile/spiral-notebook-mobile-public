import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/common/parking_lot_icon.dart';
import 'package:spiral_notebook/components/parking_lot/parking_lot_artifacts_empty.dart';
import 'package:spiral_notebook/models/artifact/artifact.dart';
import 'package:spiral_notebook/screens/artifact_details_screen.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class ParkingLotArtifactsList extends StatelessWidget {
  const ParkingLotArtifactsList({
    Key? key,
    required this.artifacts,
  }) : super(key: key);

  final List<Artifact> artifacts;

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry _rowPadding = const EdgeInsets.symmetric(vertical: 8.0);

    return (artifacts.isEmpty)
        ? ParkingLotArtifactsListEmpty()
        : ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16.0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: artifacts.length,
      itemBuilder: (context, index) {
        Artifact artifact = artifacts[index];

        return Padding(
          padding: _rowPadding,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtifactDetailsScreen(
                artifactId: artifact.id,
                portfolioId: artifact.portfolioId,
              )));
            },
            style: ElevatedButton.styleFrom(
              elevation: 0.0, backgroundColor: Colors.white,
              side: BorderSide(width: 1.0, color: primaryButtonBlue),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  ParkingLotIcon(inverted: true, size: 40.0, fontSize: 22.0),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(artifact.name, style: TextStyle(color: primaryButtonBlue, fontSize: 12.0 )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
