import 'package:spiral_notebook/api/eqis_api.dart';


class SharedArtifactsCommentsService {
  final _comments = EqisAPI();

  Future<dynamic> fetchSharedArtifactsComments() async {
    final comments = await _comments.fetchSharedArtifactsComments();

    return comments;
  }

  Future<dynamic> addSharedArtifactComment({
    required String sharedArtifactId,
    required String commentText,
  }) async {

    final commentJson = await _comments.addSharedArtifactComment(
      sharedArtifactId: sharedArtifactId,
      commentText: commentText,
    );

    return commentJson;
  }

  Future<dynamic> editSharedArtifactComment({
    required String commentId,
    required String commentText,
  }) async {

    final commentJson = await _comments.editSharedArtifactComment(
      commentId: commentId,
      commentText: commentText,
    );

    return commentJson;
  }

  Future<dynamic> deleteSharedArtifactComment({required String commentId}) async {

    final commentJson = await _comments.deleteSharedArtifactComment(commentId: commentId);

    return commentJson;
  }

}