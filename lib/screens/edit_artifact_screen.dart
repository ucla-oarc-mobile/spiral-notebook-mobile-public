import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/api/response_object_with_parent_cache.dart';
import 'package:spiral_notebook/components/artifact/artifact_floating_footer.dart';
import 'package:spiral_notebook/components/question/question_builder.dart';
import 'package:spiral_notebook/models/artifact/artifact.dart';
import 'package:spiral_notebook/models/questions/question.dart';
import 'package:spiral_notebook/models/response/file_response_remote.dart';
import 'package:spiral_notebook/models/response/file_responses_transient_editor.dart';
import 'package:spiral_notebook/models/response/text_responses_transient_single_editor.dart';
import 'package:spiral_notebook/models/shared_artifact/shared_artifact.dart';
import 'package:spiral_notebook/providers/artifact_operations_provider.dart';
import 'package:spiral_notebook/providers/artifacts_provider.dart';
import 'package:spiral_notebook/providers/shared_artifacts_provider.dart';
import 'package:spiral_notebook/screens/artifact_details_screen.dart';
import 'package:spiral_notebook/screens/shared_artifact_details_screen.dart';
import 'package:spiral_notebook/services/answers_service.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:spiral_notebook/utilities/loading.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';


class EditArtifactScreen extends ConsumerStatefulWidget {
  const EditArtifactScreen({
    required this.universalPortfolioId,
    required this.universalArtifactId,
    required this.artifactDateModified,
    required this.fileType,
    required this.promptKey,
    Key? key,
  }) : super(key: key);

  final String universalArtifactId;
  final String universalPortfolioId;
  final DateTime artifactDateModified;
  final String promptKey;
  final ModifyArtifactFileType fileType;

  @override
  _EditArtifactScreenState createState() => _EditArtifactScreenState();
}

class _EditArtifactScreenState extends ConsumerState<EditArtifactScreen> {

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
                    print('exiting response editor');
                    // dismiss the dialog
                    Navigator.of(context).pop();
                    onClose.call();
                  }),
            ],
          );
        });
  }

  void showWarningConfirmation(Function() onConfirm, String message) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Edit Conflict Warning"),
            content: Text(
                message),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Don't Save"),
                onPressed: () {
                  // dismiss the dialog.
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text("Save Anyway"),
                  onPressed: () {
                    print('exiting response editor');
                    // dismiss the dialog
                    Navigator.of(context).pop();
                    onConfirm.call();
                  }),
            ],
          );
        });
  }

  void showErrorAlert(String message) async {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user can tap anywhere to dismiss
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Edit Conflict Error"),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }


  // navigation methods
  void closePage() {
    // perform any necessary cleanup before closing this page.
    // .autoDispose will clear the transientResponses.
    // exit to the dashboard
    Navigator.of(context).pop();
  }

  Future<bool> submitFileResponses() async {
    bool cancelAction = false;
    // we do *not* add the submitToParking lot param here,
    // because we assume that adding File responses alone does NOT
    // change whether an artifact is complete.
    // We also assume that File Responses come first, before the other
    // questions, so we don't have to check for FileResponses being
    // complete - completion is entirely dependent on the Core text questions.

      try {
        transientFileResponses.validateFileResponses();
      } catch (e) {
        String message = (e is FormatException)
            ? e.message
            : "Error, please try again.";
        showSnackAlert(context, message);
        // cancel the rest, we have an invalid response.
        cancelAction = true;
        return cancelAction;
      }

      // if there are no local responses, nothing to do! Skip this.
      if (transientFileResponses.responsesLocal.responses.length == 0) return cancelAction;
      try {
        // upload in progress
        int startingResponsesCount = transientFileResponses.responsesLocalCount;
        showLoading(context, (startingResponsesCount == 1)
            ? 'Saving $startingResponsesCount File...'
            : 'Saving $startingResponsesCount Files...' );

        /*
        - while responsesLocal.length > 0
          - call uploadLocalToRemote() on the transientFE.
          + it returns the JSON from this SINGLE upload.
          - update the Artfacts Provider via this new JSON.
         */
        int localResponsesRemaining = startingResponsesCount;
        while (localResponsesRemaining > 0) {
          ResponseObjectWithParentCache fileReplaceResponseBundle = await transientFileResponses.replaceFirstLocalWithRemote();
          final FileResponseRemote fileResponse = fileReplaceResponseBundle.responseObj;

          localResponsesRemaining = transientFileResponses.responsesLocalCount;

          // handle uploading file responses for both Artifacts and SharedArtifacts.
          switch (currentArtifactOperationType) {
            case ArtifactOperationType.artifact:
              ref.read(artifactsProvider.notifier).updateWithAddedFile(
                artifactId: widget.universalArtifactId,
                fileResponse: fileResponse,
                artifactJSON: fileReplaceResponseBundle.parentJSON,
              );
              break;
            case ArtifactOperationType.sharedArtifact:
              ref.read(sharedArtifactsProvider.notifier).updateWithAddedFile(
                sharedArtifactId: widget.universalArtifactId,
                fileResponse: fileResponse,
                sharedArtifactJSON: fileReplaceResponseBundle.parentJSON,
              );
              break;
            case ArtifactOperationType.none:
              throw Exception('No artifact operation type specified in Edit Artifact Screen submitFileResponses local response upload queue!');
          }
        }

        Navigator.pop(context);
        final String completeMessage = (startingResponsesCount == 1)
            ? '$startingResponsesCount File Uploaded!'
            : '$startingResponsesCount Files Uploaded!';
        showSnackAlert(context, completeMessage);

      } catch (e) {
        Navigator.pop(context);
        String message = (e is HttpException)
            ? e.message
            : "Error uploading, please try again.";
        showSnackAlert(context, message);
        cancelAction = true;
        return cancelAction;
      }

    return cancelAction;
  }


  Future<bool> submitTextResponses() async {
    bool cancelAction = false;

    if (transientTextResponse.synced == false) {
      try {
        transientTextResponse.validate();
      } catch (e) {
        String message = (e is FormatException)
            ? e.message
            : "Error, please try again.";
        showSnackAlert(context, message);
        // cancel the rest, we have an invalid response.
        cancelAction = true;
        return cancelAction;
      }

      try {
        showLoading(context, 'Saving Changes...');
        final AnswersService _answers = AnswersService();

        final Map<String, dynamic> editPayload = transientTextResponse.getEditPayload();
        Map<String, dynamic> universalArtifactJson = {};

        // handle submitting text responses for both Artifacts and SharedArtifacts.
        switch (currentArtifactOperationType) {
          case ArtifactOperationType.artifact:
            universalArtifactJson = await _answers.submitArtifactTextResponses(
              body: editPayload,
              portfolioId: widget.universalPortfolioId,
              artifactId: widget.universalArtifactId,
            );
            transientTextResponse.markSynced();
            ref.read(artifactsProvider.notifier).updateWithArtifactJson(universalArtifactJson);
            break;
          case ArtifactOperationType.sharedArtifact:
            universalArtifactJson = await _answers.submitSharedArtifactTextResponses(
              body: editPayload,
              sharedPortfolioId: widget.universalPortfolioId,
              sharedArtifactId: widget.universalArtifactId,
            );
            transientTextResponse.markSynced();
            ref.read(sharedArtifactsProvider.notifier).updateWithSharedArtifactJson(universalArtifactJson);
            break;
          case ArtifactOperationType.none:
            throw Exception('No artifact operation type specified in Edit Artifact Screen submitTextResponses!');
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

  // exit,
  void exitAction() {
    bool isResponseSynced = false;
    if (currentQuestion.type == QuestionType.files) {
      bool localResponsesRemaining = transientFileResponses.responsesLocalCount > 0;
      isResponseSynced = !localResponsesRemaining;
    } else {
      isResponseSynced = transientTextResponse.synced;
    }
      (isResponseSynced) ? closePage() : showExitConfirmation(closePage);
  }

  void gateCheckSaveAction() async {
    if (currentArtifactOperationType == ArtifactOperationType.sharedArtifact
        && currentQuestion.type != QuestionType.files
      && transientTextResponse.synced == false) {
      // only gate check on:
      // - shared artifact AND
      // - NOT a files response AND
      // - unsynced text response

      try {
        showLoading(context, 'Saving Changes...');
        final AnswersService _answers = AnswersService();
        Map<String, dynamic> gateCheckJson = {};
        gateCheckJson = await _answers.gateCheckSharedArtifactEdit(
          sharedPortfolioId: widget.universalPortfolioId,
          sharedArtifactId: widget.universalArtifactId,
          dateModified: widget.artifactDateModified,
        );
        // gateCheck returns `type` and `message`.
        // Expected type values are String error, warning, ok
        dismissLoading(context);

        String message = gateCheckJson['message'];
        switch (gateCheckJson['type']) {
          case "error":
            showErrorAlert(message);
            break;

          case "warning":
            showWarningConfirmation(saveAction, message);
            break;

          case "ok":
          default:
            saveAction();
            break;
        }
      } catch (e) {
        Navigator.pop(context);
        String message = (e is HttpException)
            ? e.message
            : "Error submitting changes, please try again.";
        showSnackAlert(context, message);
      }
    } else {
      saveAction();
    }
  }

  // Attempt to save the Artifact/Shared Artifact responses.
  void saveAction() async {

    bool cancelAction = false;

    if (currentQuestion.type == QuestionType.files) {
      cancelAction = await submitFileResponses();
      if (cancelAction) return;
    } else {

      cancelAction = await submitTextResponses();
      if (cancelAction) return;
    }
    closePage();
  }

  // should be either SharedArtifact or Artifact, nothing else.
  Artifact? currentArtifact;
  SharedArtifact? currentSharedArtifact;

  late Question currentQuestion;

  late TextResponseTransientSingleEditor transientTextResponse;
  late FileResponsesTransientEditor transientFileResponses;

  late ArtifactOperationType currentArtifactOperationType;

  late String appBarHeading;

  @override
  void initState() {

    currentArtifactOperationType = ref.read(artifactOperationTypeProvider);

    switch (currentArtifactOperationType) {

      case ArtifactOperationType.artifact:
        currentArtifact = ref.read(artifactDetailProvider(widget.universalArtifactId));
        currentQuestion = Question.fromStructure(currentArtifact!.getStructureRowJson(widget.promptKey), 0);
        appBarHeading = 'Edit Artifact';
        break;
      case ArtifactOperationType.sharedArtifact:
        currentSharedArtifact = ref.read(sharedArtifactDetailProvider(widget.universalArtifactId));
        currentQuestion = Question.fromStructure(currentSharedArtifact!.getStructureRowJson(widget.promptKey), 0);
        appBarHeading = 'Edit Shared Artifact';
        break;
      case ArtifactOperationType.none:
        throw Exception('No artifact operation type declared in EditArtifactScreen initState!');
    }

    // initialize one of the responses, based on our Question's type.

    if (currentQuestion.type == QuestionType.files) {
      final FileResponsesTransientEditorManager frtem = ref.read(fileResponsesTransientEditorProvider.notifier);

      switch (currentArtifactOperationType) {

        case ArtifactOperationType.artifact:
          frtem.initWithArtifact(currentArtifact!);
          break;
        case ArtifactOperationType.sharedArtifact:
          frtem.initWithSharedArtifact(currentSharedArtifact!);
          break;
        case ArtifactOperationType.none:
          throw Exception('No artifact operation type declared in EditArtifactScreen initState!');
      }
      transientFileResponses = ref.read(fileResponsesTransientEditorProvider);

    } else {
      final TextResponseTransientSingleEditorManager trtsem = ref.read(textResponsesTransientSingleEditorProvider.notifier);

      switch (currentArtifactOperationType) {

        case ArtifactOperationType.artifact:
          trtsem.initWithQuestion(question: currentQuestion, value: currentArtifact!.getTextValueByKey(widget.promptKey));
          break;
        case ArtifactOperationType.sharedArtifact:
          trtsem.initWithQuestion(question: currentQuestion, value: currentSharedArtifact!.getTextValueByKey(widget.promptKey));
          break;
        case ArtifactOperationType.none:
          throw Exception('No artifact operation type declared in EditArtifactScreen initState!');
      }
      transientTextResponse = ref.read(textResponsesTransientSingleEditorProvider);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryButtonBlue,
        leading: GestureDetector(
          onTap: exitAction,
          child: Semantics(
            button: true,
            enabled: true,
            child: Icon(Icons.arrow_back_sharp, color: Colors.white, semanticLabel: 'Back'),
          ),
        ),
        title: Text(appBarHeading),
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
                          QuestionBuilder(
                            question: currentQuestion,
                            onUpdate: (dynamic updatedValue, Question question) {
                              print('update callback! $updatedValue');
                            },
                            fileType: widget.fileType,
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
                onRightTapUp: gateCheckSaveAction,
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
