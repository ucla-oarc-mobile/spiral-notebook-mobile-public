import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/common/inline_section_header.dart';
import 'package:spiral_notebook/components/common/inline_section_text.dart';
import 'package:spiral_notebook/models/artifact/artifact.dart';
import 'package:spiral_notebook/models/artifact/artifacts.dart';
import 'package:spiral_notebook/models/portfolio/portfolio.dart';
import 'package:spiral_notebook/providers/artifacts_provider.dart';
import 'package:spiral_notebook/providers/universal_artifacts_list_sorted_provider.dart';

import 'myportfolio_artifacts_list.dart';

final filteredPortfolioArtifactsProvider = Provider.family<List<Artifact>, Portfolio>((ref, filter) {
  final Artifacts artifacts = ref.watch(artifactsProvider);
  final UniversalArtifactsListSortOrder sortOrder = ref.watch(artifactsListSortOrderProvider);
  final UniversalArtifactsListSortCriteria sortCriteria = ref.watch(artifactsListSortCriteriaProvider);

  List<Artifact> result = [...artifacts.artifacts.where((artifact) => filter.artifactIds.contains(artifact.id)).toList()];

  if (result.isEmpty) return result;

  switch (sortCriteria) {

    case UniversalArtifactsListSortCriteria.inParkingLot:
      result.sort((a, b) {
        // compareTo implementation that sorts by boolean values.
        if (a.inParkingLot == b.inParkingLot) {
          // sort remainder by date created
          if (a.dateCreated.isAtSameMomentAs(b.dateCreated)) return 0;
          if (a.dateCreated.isBefore(b.dateCreated)) return 1;
          return -1;
        } else if (a.inParkingLot) {
          return -1;
        }
        return 1;
      });
      break;
    case UniversalArtifactsListSortCriteria.dateCreated:
      result.sort((a, b) =>
      (a.dateCreated.compareTo(b.dateCreated)));
      break;
    case UniversalArtifactsListSortCriteria.name:
      result.sort((a, b) {
        // this method stores the result
        // of the string comparison, in case
        // the strings are equal we can then sort by date.
        int stringComparison = (a.name.compareTo(b.name));
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
    case UniversalArtifactsListSortCriteria.author:
    throw Exception('invalid sort criteria for standard Artifact');
  }
  if (sortOrder == UniversalArtifactsListSortOrder.descending)
      return result.reversed.toList();

  return result;
});

class MyPortfolioArtifactsTable extends ConsumerWidget {
  MyPortfolioArtifactsTable({
    Key? key,
    required this.selectedPortfolio,
  }) : super(key: key);

  final Portfolio selectedPortfolio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Artifact> artifacts = ref.watch(filteredPortfolioArtifactsProvider(selectedPortfolio));

    return Column(
      children: [
        SizedBox(height: 8),
        InlineSectionHeader(label: 'Artifacts'),
        (artifacts.isNotEmpty)
            ? MyPortfolioArtifactsList(artifacts: artifacts)
            : InlineSectionText(label: 'No Artifacts for this portfolio.'),
      ],
    );
  }
}
