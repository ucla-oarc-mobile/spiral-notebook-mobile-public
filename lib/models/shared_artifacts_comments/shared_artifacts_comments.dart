
import 'package:hive/hive.dart';
import 'package:spiral_notebook/models/shared_artifacts_comments/shared_artifacts_comment.dart';

part 'shared_artifacts_comments.g.dart';

@HiveType(typeId: 9)
class SharedArtifactsComments {
  @HiveField(0)
  List<SharedArtifactsComment> comments;

  SharedArtifactsComments(this.comments);

  SharedArtifactsComment getById(String id) => comments.firstWhere(
        (comment) => comment.id == id,
    orElse: () => throw Exception('invalid Shared Artifact Comment ID $id'),
  );

  static List<SharedArtifactsComment> listFromComments(List<dynamic> commentsJson) {
    List<SharedArtifactsComment> commentsList = [];

    commentsJson.forEach((commentJson) {
      commentsList.add(SharedArtifactsComment.fromJson(
        parsedJson: commentJson,
      ));
    });

    // ensure that all artifacts are sorted by date created. Critical!
    commentsList
        .sort((a, b) => (a.dateCreated.compareTo(b.dateCreated)));
    return commentsList;
  }

  SharedArtifactsComments withUpdatedCommentJson(Map<String, dynamic> commentJson) {

    List<SharedArtifactsComment> copyComments = [...comments];

    final String commentId = '${commentJson['id']}';

    int indexToReplace = copyComments.indexWhere((comment) => comment.id == commentId);
    SharedArtifactsComment newComment = SharedArtifactsComment.fromJson(parsedJson: commentJson);

    (indexToReplace == -1)
        ? copyComments.add(newComment)
        : copyComments[indexToReplace] = newComment;

    return SharedArtifactsComments(copyComments);
  }

  SharedArtifactsComments withRemovedCommentById(String commentId) {

    List<SharedArtifactsComment> copyComments = [...comments];

    int indexToRemove = copyComments.indexWhere((comment) => comment.id == commentId);
    assert(indexToRemove != -1);

    copyComments.removeAt(indexToRemove);

    return SharedArtifactsComments(copyComments);
  }

  SharedArtifactsComments.fromJson(List<dynamic> parsedJson)
      : comments = listFromComments(parsedJson);
}