import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/common/parking_lot_icon.dart';
import 'package:spiral_notebook/components/common/universal_artifacts_list_sort_header.dart';
import 'package:spiral_notebook/models/artifact/artifact.dart';
import 'package:spiral_notebook/providers/universal_artifacts_list_sorted_provider.dart';
import 'package:spiral_notebook/screens/artifact_details_screen.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class MyPortfolioArtifactsList extends ConsumerStatefulWidget {
  const MyPortfolioArtifactsList({
    Key? key,
    required this.artifacts,
  }) : super(key: key);

  final List<Artifact> artifacts;

  @override
  ConsumerState<MyPortfolioArtifactsList> createState() => _MyPortfolioArtifactsListState();
}

class _MyPortfolioArtifactsListState extends ConsumerState<MyPortfolioArtifactsList> {

  late UniversalArtifactsListSortOrder currentDateOrder;
  late UniversalArtifactsListSortOrder currentNameOrder;
  late UniversalArtifactsListSortOrder currentParkingOrder;

  late UniversalArtifactsListSortCriteria currentSortCriteria;

  @override
  void initState() {
    super.initState();

    currentDateOrder = ref.read(artifactsListSortOrderProvider);
    currentNameOrder = ref.read(artifactsListSortOrderProvider);
    currentParkingOrder = ref.read(artifactsListSortOrderProvider);

    currentSortCriteria = ref.read(artifactsListSortCriteriaProvider);
  }

  @override
  Widget build(BuildContext context) {

    void updateSortProviders(UniversalArtifactsListSortCriteria mySortCriteria, UniversalArtifactsListSortOrder mySortOrder) {
      ref.read(artifactsListSortCriteriaProvider.notifier).state = mySortCriteria;
      ref.read(artifactsListSortOrderProvider.notifier).state = mySortOrder;
    }


    void toggleNameSort() {
      setState(() {
        if (currentSortCriteria == UniversalArtifactsListSortCriteria.name) {
          (currentNameOrder == UniversalArtifactsListSortOrder.ascending)
              ? currentNameOrder = UniversalArtifactsListSortOrder.descending
              : currentNameOrder = UniversalArtifactsListSortOrder.ascending;
        } else {
          currentSortCriteria = UniversalArtifactsListSortCriteria.name;
        }
        updateSortProviders(currentSortCriteria, currentNameOrder);
      });
    }

    void toggleParkingLotSort() {
      setState(() {
        if (currentSortCriteria == UniversalArtifactsListSortCriteria.inParkingLot) {
          (currentParkingOrder == UniversalArtifactsListSortOrder.ascending)
              ? currentParkingOrder = UniversalArtifactsListSortOrder.descending
              : currentParkingOrder = UniversalArtifactsListSortOrder.ascending;
        } else {
          currentSortCriteria = UniversalArtifactsListSortCriteria.inParkingLot;
        }
        updateSortProviders(currentSortCriteria, currentParkingOrder);
      });
    }

    void toggleDateCreatedSort() {
      setState(() {
        if (currentSortCriteria == UniversalArtifactsListSortCriteria.dateCreated) {
          (currentDateOrder == UniversalArtifactsListSortOrder.ascending)
              ? currentDateOrder = UniversalArtifactsListSortOrder.descending
              : currentDateOrder = UniversalArtifactsListSortOrder.ascending;
        } else {
          currentSortCriteria = UniversalArtifactsListSortCriteria.dateCreated;
        }
        updateSortProviders(currentSortCriteria, currentDateOrder);
      });
    }

    Widget getRowBody({required Widget child, required EdgeInsetsGeometry padding}) {
      return Flexible(
        child: FractionallySizedBox(
            widthFactor: 1,
            child: Padding(padding: padding, child: child),
        ),
      );
    }

    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.artifacts.length,
        itemBuilder: (context, index) {
          Artifact artifact = widget.artifacts[index];

          return Column(
            children: [
              index == 0 ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  UniversalArtifactsListSortHeader(
                    colorCriteria: UniversalArtifactsListSortCriteria.name,
                    iconToggleFlipCondition: (currentNameOrder == UniversalArtifactsListSortOrder.ascending),
                    isSharedArtifact: false,
                    label: 'Name',
                    padding: artifactsListOuterPaddingLeft,
                    sortToggleCallback: toggleNameSort,
                  ),
                  UniversalArtifactsListSortHeader(
                    colorCriteria: UniversalArtifactsListSortCriteria.inParkingLot,
                    iconToggleFlipCondition: (currentParkingOrder == UniversalArtifactsListSortOrder.ascending),
                    isSharedArtifact: false,
                    label: 'Parking Lot',
                    padding: artifactsListInteriorPadding,
                    sortToggleCallback: toggleParkingLotSort,
                  ),
                  UniversalArtifactsListSortHeader(
                    colorCriteria: UniversalArtifactsListSortCriteria.dateCreated,
                    iconToggleFlipCondition: (currentDateOrder == UniversalArtifactsListSortOrder.ascending),
                    isSharedArtifact: false,
                    label: 'Date',
                    padding: artifactsListOuterPaddingRight,
                    sortToggleCallback: toggleDateCreatedSort,
                  ),
                ],
              ) : SizedBox(),
              Divider(thickness: 2.0),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtifactDetailsScreen(
                    artifactId: artifact.id,
                    portfolioId: artifact.portfolioId,
                  )));
                },
                child: Semantics(
                  button: true,
                  child: Padding(
                    padding: artifactsListRowPadding,
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            getRowBody(
                                child: Text(
                                    artifact.name,
                                    style: artifact.inParkingLot
                                        ? artifactsListNameColumnStyle.copyWith(fontStyle: FontStyle.italic)
                                        : artifactsListNameColumnStyle,
                                ),
                              padding: artifactsListOuterPaddingLeft,
                            ),
                            getRowBody(
                                child: artifact.inParkingLot
                                    ? Align(alignment: Alignment.centerLeft, child: ParkingLotIcon())
                                    : SizedBox(),
                              padding: artifactsListInteriorPadding,
                            ),
                            getRowBody(
                              child: Text(
                                  artifact.formattedDateCreated,
                                  style: artifact.inParkingLot
                                      ? artifactsListDateColumnStyle.copyWith(fontStyle: FontStyle.italic)
                                      : artifactsListDateColumnStyle,
                              ),
                              padding: artifactsListOuterPaddingRight,
                            ),
                          ],
                        ),
                        Positioned.fill(
                          // This Positioned.fill is combined with a Stack
                          // to ensure the "next" icon is always in the same place
                          // while not breaking the "columns" of the layout.
                          child: Padding(
                            padding: artifactsListOuterPaddingRight,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.keyboard_arrow_right, color: primaryButtonBlue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              index == widget.artifacts.length - 1 ? Divider(thickness: 2.0) : SizedBox(),
            ],
          );
        });
  }
}
