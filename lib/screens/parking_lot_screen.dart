import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/parking_lot/parking_lot_artifacts_list.dart';
import 'package:spiral_notebook/components/common/parking_lot_icon.dart';
import 'package:spiral_notebook/models/artifact/artifact.dart';
import 'package:spiral_notebook/models/artifact/artifacts.dart';
import 'package:spiral_notebook/providers/artifacts_provider.dart';
import 'package:spiral_notebook/utilities/constants.dart';

final filteredArtifactsProvider = Provider<List<Artifact>>((ref) {
  final Artifacts artifacts = ref.watch(artifactsProvider);
  return artifacts.artifacts.where((artifact) => artifact.inParkingLot).toList();
});

class ParkingLotScreen extends ConsumerWidget {
  static String id = 'parking_lot_screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Artifact> artifacts = ref.watch(filteredArtifactsProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: "Back",
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            ParkingLotIcon(inverted: true),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text('Parking Lot'.toUpperCase()),
            ),
          ],
        ),
        backgroundColor: primaryButtonBlue,
        actions: null,
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      child: Text('Complete the submission of the following artifacts:', style: TextStyle(
                        fontSize: 16.0,
                      ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ParkingLotArtifactsList(
                      artifacts: artifacts,
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
