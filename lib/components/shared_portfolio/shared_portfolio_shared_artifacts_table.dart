import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/common/inline_section_header.dart';
import 'package:spiral_notebook/components/common/inline_section_text.dart';
import 'package:spiral_notebook/components/shared_portfolio/shared_portfolio_shared_artifacts_list.dart';
import 'package:spiral_notebook/models/shared_artifact/shared_artifact.dart';
import 'package:spiral_notebook/models/shared_artifact/shared_artifacts.dart';
import 'package:spiral_notebook/models/shared_portfolio/shared_portfolio.dart';
import 'package:spiral_notebook/providers/shared_artifacts_provider.dart';
import 'package:spiral_notebook/providers/universal_artifacts_list_sorted_provider.dart';


final filteredSharedPortfolioSharedArtifactsProvider = Provider.family<List<SharedArtifact>, SharedPortfolio>((ref, filter) {
  final SharedArtifacts artifacts = ref.watch(sharedArtifactsProvider);
  final UniversalArtifactsListSortOrder sortOrder = ref.watch(sharedArtifactsListSortOrderProvider);
  final UniversalArtifactsListSortCriteria sortCriteria = ref.watch(sharedArtifactsListSortCriteriaProvider);

  List<SharedArtifact> result = [...artifacts.artifacts.where((artifact) => filter.artifactIds.contains(artifact.id)).toList()];

  if (result.isEmpty) return result;

  switch (sortCriteria) {


    case UniversalArtifactsListSortCriteria.dateCreated:
      result.sort((a, b) =>
      (a.dateCreated.compareTo(b.dateCreated)));
      break;
    case UniversalArtifactsListSortCriteria.author:
      result.sort((a, b) {
        // this method stores the result
        // of the string comparison, in case
        // the strings are equal we can then sort by date.
        // int stringComparison = (a.ownerName.compareTo(b.ownerName));

        // the actual property should be ownerName, but that's not currently
        // being returned by the API.
        int stringComparison = (a.displayName.compareTo(b.displayName));
        if (stringComparison == 0) {
          // sort remainder by date created
          if (a.dateCreated.isAtSameMomentAs(b.dateCreated)) return 0;
          if (a.dateCreated.isBefore(b.dateCreated)) return -1;
          return 1;
        } else {
          return stringComparison;
        }
      });
      break;
    case UniversalArtifactsListSortCriteria.inParkingLot:
    case UniversalArtifactsListSortCriteria.name:
      throw Exception('invalid sort criteria for Shared Artifact');
  }
  if (sortOrder == UniversalArtifactsListSortOrder.descending)
    return result.reversed.toList();

  return result;
});

class SharedPortfolioSharedArtifactsTable extends ConsumerWidget {
  SharedPortfolioSharedArtifactsTable({
    Key? key,
    required this.selectedPortfolio,
  }) : super(key: key);

  final SharedPortfolio selectedPortfolio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<SharedArtifact> sharedArtifacts = ref.watch(filteredSharedPortfolioSharedArtifactsProvider(selectedPortfolio));

    return Column(
      children: [
        SizedBox(height: 8),
        InlineSectionHeader(label: 'Artifacts'),
        (sharedArtifacts.isNotEmpty)
            ? SharedPortfolioSharedArtifactsList(sharedArtifacts: sharedArtifacts)
            : InlineSectionText(label: 'No Shared Artifacts for this shared portfolio.'),
      ],
    );
  }
}
