import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/artifact/artifact_data_dual_header.dart';
import 'package:spiral_notebook/components/artifact/artifact_floating_footer.dart';
import 'package:spiral_notebook/components/artifact/artifact_input_multi_text.dart';
import 'package:spiral_notebook/models/auth/current_user.dart';
import 'package:spiral_notebook/models/shared_artifacts_comments/shared_artifacts_comment.dart';
import 'package:spiral_notebook/providers/current_user_provider.dart';
import 'package:spiral_notebook/providers/shared_artifact_comments_provider.dart';
import 'package:spiral_notebook/services/shared_artifacts_comments_service.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:spiral_notebook/utilities/loading.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';

enum SharedArtifactCommentOperation {
  add,
  edit,
}

class SharedArtifactCommentOperationScreen extends ConsumerStatefulWidget {
  const SharedArtifactCommentOperationScreen({
    Key? key,
    required this.sharedArtifactId,
    required this.sharedPortfolioId,
    this.commentId,
  }) : super(key: key);

  final String sharedArtifactId;
  final String sharedPortfolioId;
  final String? commentId;
  @override
  _SharedArtifactCommentOperationScreenState createState() => _SharedArtifactCommentOperationScreenState();
}

class _SharedArtifactCommentOperationScreenState extends ConsumerState<SharedArtifactCommentOperationScreen> {

  late CurrentAuthUser currentUser;
  SharedArtifactsComment? currentComment;
  bool changesSynced = true;
  late SharedArtifactCommentOperation currentOperation;

  late String appBarLabel;

  String? operationTimestamp;

  String? commentHintText;

  String? initialOperationValue;

  String? currentOperationValue;

  void showExitConfirmation(Function() onClose) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Unsaved Changes"),
            content: Text(
                "Your changes have not been saved. Are you sure you wish to exit?"),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Keep Editing"),
                onPressed: () {
                  // dismiss the dialog.
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text("Discard Changes"),
                  onPressed: () {
                    print('exiting comment editor');
                    // dismiss the dialog
                    Navigator.of(context).pop();
                    onClose.call();
                  }),
            ],
          );
        });
  }
  // navigation methods
  void closePage() {
    // perform any necessary cleanup before closing this page.
    Navigator.of(context).pop();
  }

  void exitAction() {
    (changesSynced) ? closePage() : showExitConfirmation(closePage);
  }

  validateComment(String? value) {
    if (value == null || value.isEmpty)
      throw FormatException('Please enter a comment.');
  }

  Future<bool> submitComment() async {
    bool cancelAction = false;

    try {
      validateComment(currentOperationValue);
    } catch (e) {
      String message = (e is FormatException)
          ? e.message
          : "Error, please try again.";
      showSnackAlert(context, message);
      // cancel the rest, we have an invalid comment.
      cancelAction = true;
      return cancelAction;
    }

    if (!changesSynced) {

      try {
        showLoading(context, 'Saving Changes...');
        final SharedArtifactsCommentsService _comments = SharedArtifactsCommentsService();

        Map<String, dynamic> universalCommentJson = {};

        switch (currentOperation) {
          case SharedArtifactCommentOperation.add:
            universalCommentJson = await _comments.addSharedArtifactComment(
              sharedArtifactId: widget.sharedArtifactId,
              commentText: currentOperationValue!,
            );
            changesSynced = true;
            ref.read(sharedArtifactsCommentsProvider.notifier).updateWithCommentJson(universalCommentJson);
            // TODO: update sharedArtifactsProvider comment count for the current shared artifact.
            // TODO: Update sharedPortfoliosProvider comment count for the current portfolio.
            break;
          case SharedArtifactCommentOperation.edit:
            universalCommentJson = await _comments.editSharedArtifactComment(
              commentText: currentOperationValue!,
              commentId: currentComment!.id,
            );
            changesSynced = true;
            ref.read(sharedArtifactsCommentsProvider.notifier).updateWithCommentJson(universalCommentJson);
            break;
        }

        // merge onSubmitSuccess json back into Artifact!
        showSnackAlert(context, 'Changes Saved!');

        dismissLoading(context);
      } catch (e) {
        Navigator.pop(context);
        String message = (e is HttpException)
            ? e.message
            : "Error submitting changes, please try again.";
        showSnackAlert(context, message);
        cancelAction = true;
        return cancelAction;
      }
    }
    return cancelAction;
  }

  // footer action button handlers
  void rightFooterActionButton() async {

    bool cancelAction = false;

    cancelAction = await submitComment();
    if (cancelAction) return;
    closePage();
  }

  @override
  void initState() {
    super.initState();

    currentUser = ref.read(currentUserProvider);

    currentOperation = (widget.commentId == null)
        ? SharedArtifactCommentOperation.add
        : SharedArtifactCommentOperation.edit;

    switch (currentOperation) {
      case SharedArtifactCommentOperation.add:
        appBarLabel = 'Add Comment';
        commentHintText = 'Add a new comment';
        break;
      case SharedArtifactCommentOperation.edit:
        appBarLabel = 'Edit Comment';
        commentHintText = 'Please enter a comment.';
        currentComment = ref.read(sharedArtifactsCommentsProvider).getById(widget.commentId!);
        operationTimestamp = currentComment!.formattedDateCreated;
        initialOperationValue = currentComment!.body;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(appBarLabel.toUpperCase()),
        backgroundColor: primaryButtonBlue,
        actions: null,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Stack(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: [
                GestureDetector(
                  onTap: () {
                    // enable dismissing keyboard by tapping outside input field.
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ArtifactDataDualHeader(mainHead: currentUser.myUser!.username, subHead: operationTimestamp ?? '--'),
                            // reuse the same component that renders
                            // a multi-line artifact input text.
                            ArtifactInputMultiText(
                                hintText: commentHintText!,
                                initialValue: initialOperationValue,
                                onChanged: (value) {
                                  setState(() {
                                    currentOperationValue = value;
                                    changesSynced = (currentOperationValue == initialOperationValue);
                                  });
                                }
                            ),
                            // add clearance for footer buttons
                            SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ArtifactFloatingFooter(
                  enableButtons: true,
                  leftButtonText: 'Cancel',
                  maxWidth: viewportConstraints.maxWidth,
                  onLeftTapUp: exitAction,
                  onRightTapUp: rightFooterActionButton,
                  rightButtonText: 'Save',
                  showLeftButton: true,
                ),
              ]
          );
        },
      ),
    );
  }
}
