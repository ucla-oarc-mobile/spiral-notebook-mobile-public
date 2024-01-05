import 'package:flutter_riverpod/flutter_riverpod.dart';

// tracks the current modify operation being performed on an Artifact.
// default is `none`.
enum ArtifactOperationMode {
  none,
  add,
  edit,
}

enum ArtifactOperationType {
  none,
  artifact,
  sharedArtifact,
}

enum ModifyArtifactFileType {
  media,
  document,
}

final artifactOperationModeProvider =
  StateProvider<ArtifactOperationMode>((ref) => ArtifactOperationMode.none);

final artifactOperationTypeProvider =
    StateProvider<ArtifactOperationType>((ref) => ArtifactOperationType.none);