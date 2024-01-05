import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UniversalArtifactsListSortOrder {
  ascending,
  descending,
}

enum UniversalArtifactsListSortCriteria {
  author,
  name,
  inParkingLot,
  dateCreated,
}

final artifactsListSortOrderProvider =
  StateProvider<UniversalArtifactsListSortOrder>((ref) => UniversalArtifactsListSortOrder.ascending);

final artifactsListSortCriteriaProvider =
  StateProvider<UniversalArtifactsListSortCriteria>((ref) => UniversalArtifactsListSortCriteria.inParkingLot);

final sharedArtifactsListSortOrderProvider =
StateProvider<UniversalArtifactsListSortOrder>((ref) => UniversalArtifactsListSortOrder.descending);

final sharedArtifactsListSortCriteriaProvider =
StateProvider<UniversalArtifactsListSortCriteria>((ref) => UniversalArtifactsListSortCriteria.dateCreated);
