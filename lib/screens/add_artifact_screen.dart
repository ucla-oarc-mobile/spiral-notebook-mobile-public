import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/api/response_object_with_parent_cache.dart';
import 'package:spiral_notebook/components/artifact/appbar_progressbar.dart';
import 'package:spiral_notebook/components/artifact/artifact_floating_footer.dart';
import 'package:spiral_notebook/components/question/question_builder.dart';
import 'package:spiral_notebook/models/portfolio/portfolio.dart';
import 'package:spiral_notebook/models/questions/question.dart';
import 'package:spiral_notebook/models/questions/question_pages.dart';
import 'package:spiral_notebook/models/questions/questions.dart';
import 'package:spiral_notebook/models/response/file_response_remote.dart';
import 'package:spiral_notebook/models/response/file_responses_transient_editor.dart';
import 'package:spiral_notebook/models/response/text_responses_transient_multi_editor.dart';
import 'package:spiral_notebook/providers/artifact_operations_provider.dart';
import 'package:spiral_notebook/providers/artifacts_provider.dart';
import 'package:spiral_notebook/providers/my_portfolios_provider.dart';
import 'package:spiral_notebook/screens/home_tabs_frame.dart';
import 'package:spiral_notebook/services/answers_service.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:spiral_notebook/utilities/loading.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';


class AddArtifactScreen extends ConsumerStatefulWidget {
  const AddArtifactScreen({
    required this.portfolioId,
    required this.artifactId,
    required this.fileType,
    Key? key,
  }) : super(key: key);

  final String portfolioId;
  final String artifactId;
  final ModifyArtifactFileType fileType;

  @override
  _AddArtifactScreenState createState() => _AddArtifactScreenState();
}


class _AddArtifactScreenState extends ConsumerState<AddArtifactScreen> {


  // Page View state tracking
  double progress = 0.1;
  int currentPageIndex = 0;
  int numPages = 1;
  bool onLastPage = true;
  PageController questionSegmentController = PageController(initialPage: 0);

  //navigation methods

  void updatePageProgressState() {
    (currentPageIndex == 0 && numPages != 1)
        ? progress = 0.1
        : progress = (currentPageIndex + 1) / numPages;
  }
  void updateLastPageState() {
    onLastPage = (currentPageIndex == numPages - 1);
    footerRightButtonText = (onLastPage) ? 'Submit' : 'Next';
  }
  void animatePageSegmentState() {
    questionSegmentController.animateToPage(currentPageIndex,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic
    );
  }

  void advancePage() {
    setState(() {
      currentPageIndex++;
      updatePageProgressState();
      updateLastPageState();
      animatePageSegmentState();
    });
  }

  void closePage() {
    // perform any necessary cleanup before closing this page.
    // .autoDispose will clear the transientResponses.
    // exit to the dashboard
    Navigator.pushNamedAndRemoveUntil(context, HomeTabsFrame.id, (Route<dynamic> route) => false);
  }

  void retreatPage() {
    setState(() {
      currentPageIndex--;
      updatePageProgressState();
      updateLastPageState();
      animatePageSegmentState();
    });
  }

  void showExitConfirmation(Function() onClose) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Artifact Incomplete"),
            content: Text(
                "Your artifact is not complete. Discard any unsaved changes and exit?"),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Cancel"),
                onPressed: () {
                  // dismiss the dialog.
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text("Close Artifact"),
                  onPressed: () {
                    print('exiting artifact');
                    // dismiss the dialog
                    Navigator.of(context).pop();
                    onClose.call();
                  }),
            ],
          );
        });
  }

  // submitters
  Future<bool> submitTextResponses({required bool submitToParkingLot}) async {
    bool cancelAction = false;
    if (transientTextResponses.isPageUnsynced(currentPageIndex)) {
      try {
        transientTextResponses.validateResponsesOnPage(currentPageIndex);
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
        // upload in progress
        showLoading(context, 'Saving Responses...');
        final AnswersService _answers = AnswersService();

        final Map<String, dynamic> submitPayload = transientTextResponses.getSubmitPayload(currentPageIndex, submitToParkingLot);

        final Map<String, dynamic> artifactJson = await _answers.submitArtifactTextResponses(
          body: submitPayload,
          portfolioId: widget.portfolioId,
          artifactId: widget.artifactId,
        );
        transientTextResponses.markSyncedResponsesOnPage(currentPageIndex);

        // merge onSubmitSuccess artifactJson back into Artifacts and MyPortfolios!
        ref.read(artifactsProvider.notifier).updateWithArtifactJson(artifactJson);
        ref.read(myPortfoliosProvider.notifier).updateWithArtifactJson(artifactJson);


        dismissLoading(context);
      } catch (e) {
        Navigator.pop(context);
        String message = (e is HttpException)
            ? e.message
            : "Error submitting, please try again.";
        showSnackAlert(context, message);
        cancelAction = true;
        return cancelAction;
      }
    }
    return cancelAction;
  }

  Future<bool> validateFileResponses() async {
    bool cancelAction = false;

    if (questionPages.pageContainsFilePrompt(currentPageIndex)) {
      // We assume that there is only a single page of File responses.
      // submitFileResponses can be called on any page in the Add process.
      // Therefore, we only validate if the current page contains Files,
      // but we attempt to submit on ANY other page.
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
    }
    return cancelAction;
  }

  Future<bool> submitFileResponses() async {
    bool cancelAction = false;
    // we do *not* add the submitToParking lot param here,
    // because we assume that adding File responses alone does NOT
    // change whether an artifact is complete.
    // We also assume that File Responses come first, before the other
    // questions, so we don't have to check for FileResponses being
    // complete - completion is entirely dependent on the Core text questions.

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
          - update the Artifacts Provider via this new JSON.
         */
      int localResponsesRemaining = startingResponsesCount;
      while (localResponsesRemaining > 0) {
        ResponseObjectWithParentCache fileReplaceResponseBundle = await transientFileResponses.replaceFirstLocalWithRemote();
        final FileResponseRemote fileResponse = fileReplaceResponseBundle.responseObj;

        localResponsesRemaining = transientFileResponses.responsesLocalCount;

        // NOTE: This will generate an artifact inside of the local cache
        // whenever files are saved. The expected behavior is that
        // artifact files are only saved when the artifact is valid,
        // either when clicking Save to Parking Lot or when clicking
        // Submit button at the end of the Add Artifact workflow.
        ref.read(artifactsProvider.notifier).updateWithAddedFile(
          artifactId: widget.artifactId,
          fileResponse: fileResponse,
          artifactJSON: fileReplaceResponseBundle.parentJSON,
        );

      }

      dismissLoading(context);
      final String completeMessage = (startingResponsesCount == 1)
          ? '$startingResponsesCount File Uploaded!'
          : '$startingResponsesCount Files Uploaded!';
      showSnackAlert(context, completeMessage);

    } catch (e) {
      Navigator.pop(context);
      String message = (e is HttpException)
          ? e.message
          : "Error submitting, please try again.";
      showSnackAlert(context, message);
      cancelAction = true;
      return cancelAction;
    }
    return cancelAction;
   }

    // footer action button handlers
  void rightFooterActionButton() async {

    bool cancelAction = false;

    cancelAction = await validateFileResponses();
    if (cancelAction) return;

    if (onLastPage) {
      cancelAction = await submitFileResponses();
      if (cancelAction) return;
    }
    cancelAction = await submitTextResponses(submitToParkingLot: !onLastPage);
    if (cancelAction) return;

    (onLastPage) ? closePage() : advancePage();
  }

  void leftFooterActionButton() async {
    // same as right FAB, but inParkingLot is always true!
    /*
      - current page contains File Question?
        - transientFileResponses.validate(pageIndex)
        + async transientFileResponses.submit
    */
    bool cancelAction = false;

    cancelAction = await validateFileResponses();
    if (cancelAction) return;

    cancelAction = await submitTextResponses(submitToParkingLot: true);
    if (cancelAction) return;

    if (!transientTextResponses.isFirstSynced) {
      // There are some assumptions baked in about determining which
      // artifacts are eligible to be added to the parking lot:
      // - the files question appears on the first page.
      // - the core questions appear immediately after the files question.
      // - these core questions are all on the first page of text questions.
      // - the core questions must be synced with the server.
      // - For the above reasons, assume the following error only appears on Files questions page.
      showSnackAlert(context, 'Before saving, please complete required questions on next page.');
      return;
    }

    cancelAction = await submitFileResponses();
    if (cancelAction) return;

    closePage();
  }

  // Footer state control methods
  bool enableFooterButtons = true;
  String footerLeftButtonText = 'Save to Parking Lot';
  String footerRightButtonText = 'Next';

  // vars tracking selected items
  late Portfolio currentPortfolio;

  // tracking questions
  late Questions currentQuestions;
  late QuestionPages questionPages;

  late TextResponsesTransientMultiEditor transientTextResponses;
  late FileResponsesTransientEditor transientFileResponses;

  @override
  void initState() {

    currentPortfolio = ref.read(myPortfoliosProvider).getById(widget.portfolioId);

    // time to generate the list of questions from the portfolio!
    currentQuestions = Questions.fromPortfolio(currentPortfolio, widget.artifactId);

    numPages = currentQuestions.numPages;
    updatePageProgressState();
    updateLastPageState();

    // with a list of questions with PageIndex props,
    // it's time to split them into groups of Pages!
    questionPages = QuestionPages.fromQuestions(currentQuestions);

    final TextResponsesTransientMultiEditorManager trtmem = ref.read(textResponsesTransientMultiEditorProvider.notifier);
    final FileResponsesTransientEditorManager frtem = ref.read(fileResponsesTransientEditorProvider.notifier);

    // initialize the transient text responses provider with the current questions!
    trtmem.initWithQuestions(currentQuestions);

    frtem.initBlankWithIds(artifactId: widget.artifactId, portfolioId: widget.portfolioId);

    transientTextResponses = ref.read(textResponsesTransientMultiEditorProvider);

    transientFileResponses = ref.read(fileResponsesTransientEditorProvider);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primaryButtonBlue,
          leading: GestureDetector(
            onTap: () async {
              (currentPageIndex == 0) ? showExitConfirmation(closePage) : retreatPage();
            },
            child: Semantics(
              button: true,
              enabled: true,
              child: Icon(Icons.arrow_back_sharp, color: Colors.white, semanticLabel: 'Back'),
            ),
          ),
          title: AppBarProgressBar(progress: progress),
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
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: questionSegmentController,
                      children: questionPages.pages.map((qPage) {
                        return SingleChildScrollView(
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
                                  children: [...qPage.questionList.map((question) => QuestionBuilder(
                                    question: question,
                                    onUpdate: (dynamic updatedValue, Question question) {
                                      print('update callback! $updatedValue');
                                    },
                                    fileType: widget.fileType,
                                  )).toList(),
                                    // add clearance for footer buttons
                                    SizedBox(height: 100),
                                  ],
                                ),
                              )
                          ),
                        );
                      },
                      ).toList(),
                    ),
                  ),
                  ArtifactFloatingFooter(
                    enableButtons: enableFooterButtons,
                    leftButtonText: footerLeftButtonText,
                    maxWidth: viewportConstraints.maxWidth,
                    onLeftTapUp: leftFooterActionButton,
                    onRightTapUp: rightFooterActionButton,
                    rightButtonText: footerRightButtonText,
                    showLeftButton: true,
                  ),
                ],
              );
            }
        ),
      ),
    );
  }
}
