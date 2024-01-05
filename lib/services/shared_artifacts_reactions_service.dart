import 'package:spiral_notebook/api/eqis_api.dart';


class SharedArtifactsReactionsService {
  final _reactions = EqisAPI();

  Future<dynamic> fetchSharedArtifactsReactions() async {
    final reactions = await _reactions.fetchSharedArtifactsReactions();

    return reactions;
  }

  Future<dynamic> addSharedArtifactReaction({
    required String sharedArtifactId,
    required String reactionValue,
  }) async {
    final Map<String, dynamic> jsonResponse = await _reactions.addSharedArtifactReaction(
      sharedArtifactId: sharedArtifactId,
      reactionValue: reactionValue,
    );

    return jsonResponse;
  }

  Future<dynamic> deleteSharedArtifactReaction({required String reactionId}) async {
    final Map<String, dynamic> jsonResponse = await _reactions.deleteSharedArtifactReaction(reactionId: reactionId);

    return jsonResponse;
  }
}