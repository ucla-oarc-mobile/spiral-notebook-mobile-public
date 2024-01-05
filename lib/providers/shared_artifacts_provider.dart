
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/models/response/file_response_remote.dart';
import 'package:spiral_notebook/models/shared_artifact/shared_artifacts.dart';
import 'package:spiral_notebook/persistence/hive_data_store.dart';
import 'package:spiral_notebook/services/shared_artifacts_service.dart';

class SharedArtifactsManager extends StateNotifier<SharedArtifacts> {
  final HiveDataStore dataStore;

  SharedArtifactsManager({
    required SharedArtifacts artifacts,
    required this.dataStore,
  }) : super(artifacts);

  void refreshWithJson(List<dynamic> json) {
    state = SharedArtifacts.fromJson(json);
    dataStore.setAllSharedArtifactsJSON(sharedArtifactsJSON: json, force: true);
  }

  void updateWithSharedArtifactJson(Map<String, dynamic> sharedArtifactJson) {
    state = state.withUpdatedSingleArtifactJson(sharedArtifactJson);
    dataStore.setSharedArtifactJSON(sharedArtifactJSON: sharedArtifactJson);
  }

  void updateWithAddedFile({
    required String sharedArtifactId,
    required FileResponseRemote fileResponse,
    Map<String, dynamic>? sharedArtifactJSON,
  }) {
    state = state.withAddedArtifactFile(sharedArtifactId, fileResponse);
    if (sharedArtifactJSON == null)
      print('shared artifact JSON not cached after update for artifact ID $sharedArtifactId');
    else
      dataStore.setSharedArtifactJSON(sharedArtifactJSON: sharedArtifactJSON);
  }

  void updateWithRemovedFile({
    required String sharedArtifactId,
    required FileResponseRemote fileResponse,
    Map<String, dynamic>? sharedArtifactJSON,
  }) {
    state = state.withRemovedArtifactFile(sharedArtifactId, fileResponse);
    if (sharedArtifactJSON == null)
      print('shared artifact JSON not cached after update for artifact ID $sharedArtifactId');
    else
      dataStore.setSharedArtifactJSON(sharedArtifactJSON: sharedArtifactJSON);
  }

  void updateWithRemovedSharedArtifactId(String sharedArtifactId) {
    state = state.withRemovedSharedArtifactId(sharedArtifactId);
    dataStore.removeSharedArtifactById(sharedArtifactId);
  }

  Future<dynamic> syncSharedArtifacts() async {
    final SharedArtifactsService _sharedArtifacts = SharedArtifactsService();

    bool syncSuccess = false;

    final sharedArtifactsResult = await _sharedArtifacts.fetchSharedArtifacts();

    syncSuccess = (sharedArtifactsResult != null);

    if (syncSuccess) {
      state = SharedArtifacts.fromJson(sharedArtifactsResult);
      dataStore.setAllSharedArtifactsJSON(sharedArtifactsJSON: sharedArtifactsResult, force: true);
    }
    return sharedArtifactsResult;
  }

  void reset() {
    state = SharedArtifacts([]);
    dataStore.clearAllSharedArtifactsJSON();
  }
}

final sharedArtifactsProvider = StateNotifierProvider<SharedArtifactsManager, SharedArtifacts>((ref) {
  throw UnimplementedError();
});
