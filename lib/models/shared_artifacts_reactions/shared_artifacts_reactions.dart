
import 'package:hive/hive.dart';
import 'package:spiral_notebook/models/shared_artifacts_reactions/shared_artifacts_reaction.dart';

part 'shared_artifacts_reactions.g.dart';

@HiveType(typeId: 11)
class SharedArtifactsReactions {
  @HiveField(0)
  List<SharedArtifactsReaction> reactions;

  SharedArtifactsReactions(this.reactions);

  SharedArtifactsReaction getById(String id) => reactions.firstWhere(
        (reaction) => reaction.id == id,
    orElse: () => throw Exception('invalid Shared Artifact Reaction ID $id'),
  );

  static List<SharedArtifactsReaction> listFromReactions(List<dynamic> reactionsJson) {
    List<SharedArtifactsReaction> reactionsList = [];

    reactionsJson.forEach((reactionJson) {
      reactionsList.add(SharedArtifactsReaction.fromJson(
        parsedJson: reactionJson,
      ));
    });

    // ensure that all artifacts are sorted by date created. Critical!
    reactionsList
        .sort((a, b) => (a.dateCreated.compareTo(b.dateCreated)));
    return reactionsList;
  }


  SharedArtifactsReactions withAddedReactionJson(Map<String, dynamic> reactionJson) {

    List<SharedArtifactsReaction> copyReactions = [...reactions];

    SharedArtifactsReaction newReaction = SharedArtifactsReaction.fromJson(parsedJson: reactionJson);

    copyReactions.add(newReaction);

    return SharedArtifactsReactions(copyReactions);
  }

  SharedArtifactsReactions withRemovedReactionById(String reactionId) {

    List<SharedArtifactsReaction> copyReactions = [...reactions];

    int indexToRemove = copyReactions.indexWhere((reaction) => reaction.id == reactionId);
    assert(indexToRemove != -1);

    copyReactions.removeAt(indexToRemove);

    return SharedArtifactsReactions(copyReactions);
  }

  SharedArtifactsReactions.fromJson(List<dynamic> parsedJson)
      : reactions = listFromReactions(parsedJson);
}