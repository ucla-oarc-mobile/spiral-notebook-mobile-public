import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/models/shared_artifacts_comments/shared_artifacts_comments.dart';
import 'package:spiral_notebook/persistence/hive_data_store.dart';
import 'package:spiral_notebook/services/shared_artifacts_comments_service.dart';

class SharedArtifactsCommentsManager extends StateNotifier<SharedArtifactsComments> {
  final HiveDataStore dataStore;

  SharedArtifactsCommentsManager({
    required SharedArtifactsComments comments,
    required this.dataStore,
  }) : super(comments);

  void refreshWithJson(json) {
    state = SharedArtifactsComments.fromJson(json);
    dataStore.setSharedArtifactsComments(comments: state);
  }

  void updateWithCommentJson(Map<String, dynamic> commentJson) {
    state = state.withUpdatedCommentJson(commentJson);
    dataStore.setSharedArtifactsComments(comments: state);
  }

  void withRemovedCommentById(String commentId) {
    state = state.withRemovedCommentById(commentId);
    dataStore.setSharedArtifactsComments(comments: state);
  }

  Future<dynamic> syncComments() async {
    final SharedArtifactsCommentsService _comments = SharedArtifactsCommentsService();

    bool syncSuccess = false;

    final commentsResult = await _comments.fetchSharedArtifactsComments();

    syncSuccess = (commentsResult != null);

    if (syncSuccess) {
      state = SharedArtifactsComments.fromJson(commentsResult);
      dataStore.setSharedArtifactsComments(comments: state);
    }
  }

  void reset() {
    state = SharedArtifactsComments([]);
    dataStore.clearSharedArtifactsComments();
  }
}

final sharedArtifactsCommentsProvider = StateNotifierProvider<SharedArtifactsCommentsManager, SharedArtifactsComments>((ref) {
  throw UnimplementedError();
});
