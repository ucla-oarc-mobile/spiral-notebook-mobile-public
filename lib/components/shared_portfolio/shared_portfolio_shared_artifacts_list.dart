import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/common/universal_artifacts_list_sort_header.dart';
import 'package:spiral_notebook/models/shared_artifact/shared_artifact.dart';
import 'package:spiral_notebook/providers/universal_artifacts_list_sorted_provider.dart';
import 'package:spiral_notebook/screens/shared_artifact_details_screen.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class SharedPortfolioSharedArtifactsList extends ConsumerStatefulWidget {
  const SharedPortfolioSharedArtifactsList({
    Key? key,
    required this.sharedArtifacts,
  }) : super(key: key);

  final List<SharedArtifact> sharedArtifacts;


  @override
  _SharedPortfolioSharedArtifactsListState createState() => _SharedPortfolioSharedArtifactsListState();
}

class _SharedPortfolioSharedArtifactsListState extends ConsumerState<SharedPortfolioSharedArtifactsList> {

  late UniversalArtifactsListSortOrder currentAuthorOrder;
  late UniversalArtifactsListSortOrder currentDateOrder;

  late UniversalArtifactsListSortCriteria currentSortCriteria;

  @override
  void initState() {
    super.initState();

    currentAuthorOrder = ref.read(sharedArtifactsListSortOrderProvider);
    currentDateOrder = ref.read(sharedArtifactsListSortOrderProvider);

    currentSortCriteria = ref.read(sharedArtifactsListSortCriteriaProvider);

  }

  @override
  Widget build(BuildContext context) {

    void updateSortProviders(UniversalArtifactsListSortCriteria mySortCriteria, UniversalArtifactsListSortOrder mySortOrder) {
      ref.read(sharedArtifactsListSortCriteriaProvider.notifier).state = mySortCriteria;
      ref.read(sharedArtifactsListSortOrderProvider.notifier).state = mySortOrder;
    }

    void toggleAuthorSort() {
      setState(() {
        if (currentSortCriteria == UniversalArtifactsListSortCriteria.author) {
          (currentAuthorOrder == UniversalArtifactsListSortOrder.ascending)
              ? currentAuthorOrder = UniversalArtifactsListSortOrder.descending
              : currentAuthorOrder = UniversalArtifactsListSortOrder.ascending;
        } else {
          currentSortCriteria = UniversalArtifactsListSortCriteria.author;
        }
        updateSortProviders(currentSortCriteria, currentAuthorOrder);
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
      itemCount: widget.sharedArtifacts.length,
      itemBuilder: (context, index) {
        SharedArtifact sharedArtifact = widget.sharedArtifacts[index];

        return Column(
          children: [
            (index == 0) ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                UniversalArtifactsListSortHeader(
                  colorCriteria: UniversalArtifactsListSortCriteria.author,
                  iconToggleFlipCondition: (currentAuthorOrder == UniversalArtifactsListSortOrder.ascending),
                  isSharedArtifact: true,
                  label: 'Author',
                  padding: artifactsListOuterPaddingLeft,
                  sortToggleCallback: toggleAuthorSort,
                ),
                UniversalArtifactsListSortHeader(
                  colorCriteria: UniversalArtifactsListSortCriteria.dateCreated,
                  iconToggleFlipCondition: (currentDateOrder == UniversalArtifactsListSortOrder.ascending),
                  isSharedArtifact: true,
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SharedArtifactDetailsScreen(
                  sharedArtifactId: sharedArtifact.id,
                  sharedPortfolioId: sharedArtifact.sharedPortfolioId,
                )));
              },
              child: Padding(
                padding: artifactsListRowPadding,
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        getRowBody(
                          child: Column(
                            children: [
                              Text(
                                sharedArtifact.name,
                                style: artifactsListNameColumnStyle,
                              ),
                              Text(
                                sharedArtifact.displayName,
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          padding: artifactsListOuterPaddingLeft,
                        ),
                        getRowBody(
                          child: Text(
                            sharedArtifact.formattedDateCreated,
                            style: artifactsListDateColumnStyle,
                          ),
                          padding: artifactsListOuterPaddingRight,
                        ),
                      ],
                    ),
                    Positioned.fill(
                      // This Positioned.fill is combined with a Stack
                      // to ensure the "next" icon is always in the same place
                      // while not breaking the "columns" of the layout.
                      // TODO: Add comment count here - add it as a Row.
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
              )
            ),
            index == widget.sharedArtifacts.length - 1 ? Divider(thickness: 2.0) : SizedBox(),
          ],
        );
      },
    );
  }
}
