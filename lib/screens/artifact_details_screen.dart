import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/api/api_constants.dart';
import 'package:spiral_notebook/components/artifact/artifact_floating_footer.dart';
import 'package:spiral_notebook/components/artifact_details/artifact_details_builder.dart';
import 'package:spiral_notebook/components/common/universal_artifact_details_metadata.dart';
import 'package:spiral_notebook/components/common/inline_section_header.dart';
import 'package:spiral_notebook/models/artifact/artifact.dart';
import 'package:spiral_notebook/models/artifact/artifacts.dart';
import 'package:spiral_notebook/models/questions/questions.dart';
import 'package:spiral_notebook/providers/artifact_operations_provider.dart';
import 'package:spiral_notebook/providers/artifacts_provider.dart';
import 'package:spiral_notebook/providers/my_portfolios_provider.dart';
import 'package:spiral_notebook/screens/copy_artifact_to_shared_portfolio_screen.dart';
import 'package:spiral_notebook/screens/edit_artifact_screen.dart';
import 'package:spiral_notebook/screens/home_tabs_frame.dart';
import 'package:spiral_notebook/services/answers_service.dart';
import 'package:spiral_notebook/services/artifacts_service.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:spiral_notebook/utilities/loading.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';

final artifactDetailProvider =
    Provider.family<Artifact, String>((ref, artifactId) {
  final Artifacts artifacts = ref.watch(artifactsProvider);
  final int indexFound =
      artifacts.artifacts.indexWhere((artifact) => artifact.id == artifactId);
  assert(indexFound != -1);

  return artifacts.artifacts[indexFound];
});

class ArtifactDetailsScreen extends ConsumerStatefulWidget {
  const ArtifactDetailsScreen({
    required this.portfolioId,
    required this.artifactId,
    Key? key,
  }) : super(key: key);

  final String portfolioId;
  final String artifactId;

  @override
  _ArtifactDetailsScreenState createState() => _ArtifactDetailsScreenState();
}

enum FloatingFooterContent {
  none,
  submitToParkingLot,
  copyTo,
}

class _ArtifactDetailsScreenState extends ConsumerState<ArtifactDetailsScreen> {
  // tracking questions
  late Questions currentQuestions;

  late Artifact singleArtifact;

  late bool isComplete = false;

  late bool displayCopyTo;

  late FloatingFooterContent floatingFooterContent;

  @override
  void initState() {
    super.initState();
    singleArtifact = ref.read(artifactDetailProvider(widget.artifactId));
    currentQuestions = Questions.fromUniversalArtifact(
        singleArtifact.structure, widget.artifactId);

    if (singleArtifact.inParkingLot)
      floatingFooterContent = FloatingFooterContent.submitToParkingLot;
    else
      floatingFooterContent = FloatingFooterContent.copyTo;
    displayCopyTo = singleArtifact.inParkingLot;
  }

  @override
  Widget build(BuildContext context) {
    singleArtifact = ref.watch(artifactDetailProvider(widget.artifactId));
    currentQuestions = Questions.fromUniversalArtifact(
        singleArtifact.structure, widget.artifactId);

    Future<void> submitArtifactToPortfolio() async {
      try {
        showLoading(context, 'Submitting to Portfolio...');
        final AnswersService _answers = AnswersService();

        final Map<String, dynamic> submitToPortfolioPayload = {
          artifactParamParkingLotFlag: false
        };

        final Map<String, dynamic> artifactJson =
            await _answers.submitArtifactTextResponses(
          body: submitToPortfolioPayload,
          portfolioId: widget.portfolioId,
          artifactId: widget.artifactId,
        );

        // merge onSubmitSuccess json back into Artifact!
        ref
            .read(artifactsProvider.notifier)
            .updateWithArtifactJson(artifactJson);
        showSnackAlert(context, 'Submitted!');

        setState(() {
          floatingFooterContent = FloatingFooterContent.copyTo;
          displayCopyTo = false;
        });
        dismissLoading(context);
        // Return to previous page after submitting.
        Navigator.pop(context);
      } catch (e) {
        dismissLoading(context);
        String message = (e is HttpException)
            ? e.message
            : "Error submitting, please try again.";
        showSnackAlert(context, message);
      }
    }

    void launchCopyTo() {
      ref.read(artifactOperationTypeProvider.notifier).state = ArtifactOperationType.artifact;

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CopyArtifactToSharedPortfolioScreen(
                universalArtifactId: singleArtifact.id,
              )));
    }

    bool isArtifactComplete(Questions myQuestions, Artifact myArtifact) {
      if (myArtifact.fileResponses.responses.length == 0) return false;

      bool isComplete = true;
      // disable this feature per request.
      // Artifact is always "complete"
      // myQuestions.questions.forEach((question) {
      //   if (question.type != QuestionType.files && myArtifact.getTextValueByKey(question.promptKey) == null)
      //     isComplete = false;
      // });
      return isComplete;
    }

    Future<bool> deleteArtifact() async {

        bool cancelAction = false;

        try {
          showLoading(context, 'Deleting Artifact...');
          final ArtifactsService _artifacts = ArtifactsService();

          Map<String, dynamic> artifactJson = await _artifacts.deleteArtifact(
            artifactId: widget.artifactId,
          );

          print(artifactJson);
          dismissLoading(context);

          // Navigate, THEN remove the artifact ID, since removing it
          // while on the artifact page could cause an error.
          Navigator.pushNamedAndRemoveUntil(context, HomeTabsFrame.id, (Route<dynamic> route) => false);

          Future.delayed(Duration(milliseconds: 250), () {
            // delay for navigation to complete before removing this artifact
            // from the app's local data store.
            ref.read(artifactsProvider.notifier).updateWithRemovedArtifactId(widget.artifactId);
            ref.read(myPortfoliosProvider.notifier).updateWithRemovedArtifactId(
              artifactId: widget.artifactId,
              portfolioId: widget.portfolioId,
            );
            showSnackAlert(context, 'Artifact deleted!');
          });


        } catch (e) {
          dismissLoading(context);

          String message = (e is HttpException)
              ? e.message
              : "Error deleting artifact, please try again.";
          showSnackAlert(context, message);
          cancelAction = true;
          return cancelAction;
        }

        return cancelAction;

    }

    Future<void> confirmDelete() async {
      return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("Delete Artifact"),
              content: Text("Are you sure that you want to delete this artifact? It can't be recovered."),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Keep"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: Text("Delete"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      bool cancelAction = await deleteArtifact();
                      if (cancelAction) return;
                    }),
              ],
            );
          });
    }

    isComplete = isArtifactComplete(currentQuestions, singleArtifact);

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
        title: Text('Artifact'.toUpperCase()),
        backgroundColor: primaryButtonBlue,
        actions: <Widget>[
          IconButton(
            tooltip: 'Delete Artifact',
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () async {
              confirmDelete();
            },
          )
        ],
      ),
      body: Center(
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
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
                        InlineSectionHeader(label: singleArtifact.name),
                        UniversalArtifactDetailsMetadata(
                            universalArtifact: singleArtifact),
                        ...currentQuestions.questions
                            .map((question) => ArtifactDetailsBuilder(
                                  question: question,
                                  onTapEdit: () {
                                    // call the edit method for this particular promptKey

                                    // Set our current artifact operation mode to "Edit"
                                    // so our Question components access the appropriate Response Provider.
                                    ref
                                        .read(artifactOperationModeProvider
                                            .notifier)
                                        .state = ArtifactOperationMode.edit;
                                    ref
                                        .read(artifactOperationTypeProvider
                                            .notifier)
                                        .state = ArtifactOperationType.artifact;
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditArtifactScreen(
                                                  universalPortfolioId:
                                                      singleArtifact
                                                          .portfolioId,
                                                  universalArtifactId:
                                                      singleArtifact.id,
                                                  artifactDateModified: singleArtifact.dateModified,
                                                  fileType: singleArtifact
                                                      .modifyFileType,
                                                  promptKey: question.promptKey,
                                                )));
                                  },
                                  fileResponses: singleArtifact.fileResponses,
                                  textResponse: singleArtifact
                                      .textResponsesRemote
                                      .getValueByKey(question.promptKey),
                                ))
                            .toList(),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
              if (floatingFooterContent ==
                  FloatingFooterContent.submitToParkingLot)
                ArtifactFloatingFooter(
                  enableButtons: isComplete,
                  maxWidth: viewportConstraints.maxWidth,
                  onRightTapUp: submitArtifactToPortfolio,
                  rightButtonText: isComplete
                      ? 'Submit to Portfolio'
                      : 'Artifact Incomplete',
                  showLeftButton: false,
                ),
              if (floatingFooterContent == FloatingFooterContent.copyTo)
                ArtifactFloatingFooter(
                  enableButtons: true,
                  maxWidth: viewportConstraints.maxWidth,
                  onRightTapUp: launchCopyTo,
                  rightButtonText: 'Copy To',
                  showLeftButton: false,
                ),
            ],
          );
        }),
      ),
    );
  }
}
