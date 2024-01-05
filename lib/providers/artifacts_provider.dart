
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/models/artifact/artifacts.dart';
import 'package:spiral_notebook/models/response/file_response_remote.dart';
import 'package:spiral_notebook/persistence/hive_data_store.dart';
import 'package:spiral_notebook/services/artifacts_service.dart';

class ArtifactsManager extends StateNotifier<Artifacts> {
  final HiveDataStore dataStore;

  ArtifactsManager({
    required Artifacts artifacts,
    required this.dataStore,
  }) : super(artifacts);

  void refreshWithJson(List<dynamic> json) {
    state = Artifacts.fromJson(json);
    dataStore.setAllArtifactsJSON(artifactsJSON: json, force: true);
  }

  void updateWithArtifactJson(Map<String, dynamic> artifactJson) {
    state = state.withUpdatedSingleArtifactJson(artifactJson);
    dataStore.setArtifactJSON(artifactJSON: artifactJson);
  }

  void updateWithAddedFile({
    required String artifactId,
    required FileResponseRemote fileResponse,
    Map<String, dynamic>? artifactJSON,
  }) {
    state = state.withAddedArtifactFile(artifactId, fileResponse);
    if (artifactJSON == null)
      print('artifact JSON not cached after update for artifact ID $artifactId');
    else
      dataStore.setArtifactJSON(artifactJSON: artifactJSON);
  }

  void updateWithRemovedFile({
    required String artifactId,
    required FileResponseRemote fileResponse,
    Map<String, dynamic>? artifactJSON,
  }) {
    state = state.withRemovedArtifactFile(artifactId, fileResponse);
    if (artifactJSON == null)
      print('artifact JSON not cached after update for artifact ID $artifactId');
    else
      dataStore.setArtifactJSON(artifactJSON: artifactJSON);
  }

  void updateWithRemovedArtifactId(String artifactId) {
    state = state.withRemovedArtifactId(artifactId);
    dataStore.removeArtifactById(artifactId);
  }

  // include methods to update and delete artifact items.
  Future<dynamic> syncArtifacts() async {
    final ArtifactsService _artifacts = ArtifactsService();

    bool syncSuccess = false;

    final artifactsResult = await _artifacts.fetchArtifacts();

    syncSuccess = (artifactsResult != null);

    if (syncSuccess) {
      state = Artifacts.fromJson(artifactsResult);
      dataStore.setAllArtifactsJSON(artifactsJSON: artifactsResult, force: true);
    }
    return artifactsResult;
  }

  void reset() {
    state = Artifacts([]);
    dataStore.clearAllArtifactsJSON();
  }

}

final artifactsProvider = StateNotifierProvider<ArtifactsManager, Artifacts>((ref) {
  throw UnimplementedError();
});
