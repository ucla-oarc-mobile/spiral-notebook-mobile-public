import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/models/shared_artifacts_reactions/shared_artifacts_reactions.dart';
import 'package:spiral_notebook/persistence/hive_data_store.dart';
import 'package:spiral_notebook/services/shared_artifacts_reactions_service.dart';

class SharedArtifactsReactionsManager extends StateNotifier<SharedArtifactsReactions> {
  final HiveDataStore dataStore;

  SharedArtifactsReactionsManager({
    required SharedArtifactsReactions reactions,
    required this.dataStore,
  }) : super(reactions);

  void refreshWithJson(json) {
    state = SharedArtifactsReactions.fromJson(json);
    dataStore.setSharedArtifactsReactions(reactions: state);
  }

  void withAddedReactionJson(Map<String, dynamic> reactionJson) {
    state = state.withAddedReactionJson(reactionJson);
    dataStore.setSharedArtifactsReactions(reactions: state);
  }

  void withRemovedReactionById(String reactionId) {
    state = state.withRemovedReactionById(reactionId);
    dataStore.setSharedArtifactsReactions(reactions: state);
  }

  Future<dynamic> syncReactions() async {
    final SharedArtifactsReactionsService _reactions = SharedArtifactsReactionsService();

    bool syncSuccess = false;

    final reactionsResult = await _reactions.fetchSharedArtifactsReactions();

    syncSuccess = (reactionsResult != null);

    if (syncSuccess) {
      state = SharedArtifactsReactions.fromJson(reactionsResult);
      dataStore.setSharedArtifactsReactions(reactions: state);
    }
  }

  void reset() {
    state = SharedArtifactsReactions([]);
    dataStore.clearSharedArtifactsReactions();
  }
}

final sharedArtifactsReactionsProvider = StateNotifierProvider<SharedArtifactsReactionsManager, SharedArtifactsReactions>((ref) {
  throw UnimplementedError();
});
