import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/artifact/artifact_floating_footer.dart';
import 'package:spiral_notebook/components/common/inline_section_header.dart';
import 'package:spiral_notebook/components/shared_artifact_comment/shared_artifact_comments_empty.dart';
import 'package:spiral_notebook/components/shared_artifact_comment/shared_artifact_comment_item.dart';
import 'package:spiral_notebook/components/shared_artifact_reactions/shared_artifact_reactions_selector.dart';
import 'package:spiral_notebook/models/auth/current_user.dart';
import 'package:spiral_notebook/models/shared_artifact/shared_artifact.dart';
import 'package:spiral_notebook/models/shared_artifacts_comments/shared_artifacts_comment.dart';
import 'package:spiral_notebook/models/shared_artifacts_comments/shared_artifacts_comments.dart';
import 'package:spiral_notebook/providers/current_user_provider.dart';
import 'package:spiral_notebook/providers/shared_artifact_comments_provider.dart';
import 'package:spiral_notebook/screens/shared_artifact_comment_operation_screen.dart';
import 'package:spiral_notebook/screens/shared_artifact_details_screen.dart';
import 'package:spiral_notebook/services/shared_artifacts_comments_service.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:spiral_notebook/utilities/loading.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';


final sharedArtifactSingleCommentsProvider = Provider.family<List<SharedArtifactsComment>, String>((ref, sharedArtifactId) {

  final SharedArtifactsComments comments = ref.watch(sharedArtifactsCommentsProvider);
  final List<SharedArtifactsComment> matchingComments = comments.comments.where((comment) => comment.sharedArtifactId == sharedArtifactId).toList();

  return matchingComments;
});

class SharedArtifactCommentsScreen extends ConsumerStatefulWidget {
  const SharedArtifactCommentsScreen({
    required this.sharedArtifactId,
    Key? key,
  }) : super(key: key);

  final String sharedArtifactId;

  @override
  _SharedArtifactCommentsScreen createState() => _SharedArtifactCommentsScreen();
}

class _SharedArtifactCommentsScreen extends ConsumerState<SharedArtifactCommentsScreen> {

  late List<SharedArtifactsComment> artifactComments;
  late SharedArtifact currentSharedArtifact;
  late CurrentAuthUser currentUser;

  @override
  void initState() {
    super.initState();
    currentSharedArtifact = ref.read(sharedArtifactDetailProvider(widget.sharedArtifactId));
    artifactComments = ref.read(sharedArtifactSingleCommentsProvider(widget.sharedArtifactId));
    currentUser = ref.read(currentUserProvider);
  }

  @override
  Widget build(BuildContext context) {
    artifactComments = ref.watch(sharedArtifactSingleCommentsProvider(widget.sharedArtifactId));


    void launchAddComment() {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SharedArtifactCommentOperationScreen(
        sharedArtifactId: currentSharedArtifact.id,
        sharedPortfolioId: currentSharedArtifact.sharedPortfolioId,
      )));
    }

    void launchEditComment(String commentId) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SharedArtifactCommentOperationScreen(
        sharedArtifactId: currentSharedArtifact.id,
        sharedPortfolioId: currentSharedArtifact.sharedPortfolioId,
        commentId: commentId,
      )));
    }


    void submitDeleteComment(String commentId) async {
      try {
        showLoading(context, 'Deleting Comment...');
        final SharedArtifactsCommentsService _comments = SharedArtifactsCommentsService();

        Map<String, dynamic> universalCommentJson = await _comments.deleteSharedArtifactComment(
          commentId: commentId,
        );
        // TODO: to remove IDE warning - will likely get used later
        print('$universalCommentJson');

        ref.read(sharedArtifactsCommentsProvider.notifier).withRemovedCommentById(commentId);
        // TODO: Update sharedArtifactsProvider comment count for the current shared artifact.
        // TODO: Update sharedPortfoliosProvider comment count for the current portfolio.

        // merge onSubmitSuccess json back into Artifact!
        showSnackAlert(context, 'Comment deleted.');

        dismissLoading(context);
      } catch (e) {
        Navigator.pop(context);
        String message = (e is HttpException)
            ? e.message
            : "Error deleting comment, please try again.";
        showSnackAlert(context, message);
      }
    }

    void confirmDeleteComment(SharedArtifactsComment comment) async {

      const maxAlertBodyLength = 40;

      String commentAlertBody =  (comment.body.length > maxAlertBodyLength)
          ? comment.body.substring(0, maxAlertBodyLength - 1) + "…"
          : comment.body;

      return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("Delete this comment?"),
              content: Text(commentAlertBody),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('No, keep it'),
                  onPressed: () {
                    // dismiss the dialog.
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: Text("Yes, delete it"),
                    onPressed: () {
                      print('exiting comment editor');
                      // dismiss the dialog
                      Navigator.of(context).pop();
                      submitDeleteComment(comment.id);
                    }),
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: "Back",
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Comments'.toUpperCase()),
        backgroundColor: primaryButtonBlue,
        actions: null,
      ),
      body: Center(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 8),
                            InlineSectionHeader(label: currentSharedArtifact.name + ' Comments'),
                            SharedArtifactReactionsSelector(
                              sharedArtifactId: widget.sharedArtifactId,
                            ),
                            SizedBox(height: 10),
                            if (artifactComments.isNotEmpty)
                              ...artifactComments.map((comment) => SharedArtifactCommentItem(
                                comment: comment,
                                canModify: comment.ownedByCurrentUserId(currentUser.myUser!.id),
                                onTapDelete: () => confirmDeleteComment(comment),
                                onTapEdit: () => launchEditComment(comment.id),
                              )).toList(),
                            if (artifactComments.isEmpty)
                              SharedArtifactCommentsEmpty(),
                            SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                    ArtifactFloatingFooter(
                      enableButtons: true,
                      maxWidth: viewportConstraints.maxWidth,
                      onRightTapUp: launchAddComment,
                      rightButtonText: 'Add Comment',
                      showLeftButton: false,
                    ),
                ],
              );
            }
        ),
      ),

    );
  }
}




