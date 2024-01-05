import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/artifact/artifact_floating_footer.dart';
import 'package:spiral_notebook/models/shared_portfolio/shared_portfolios.dart';
import 'package:spiral_notebook/providers/artifact_operations_provider.dart';
import 'package:spiral_notebook/providers/shared_artifacts_provider.dart';
import 'package:spiral_notebook/providers/shared_portfolios_provider.dart';
import 'package:spiral_notebook/screens/home_tabs_frame.dart';
import 'package:spiral_notebook/screens/shared_artifact_details_screen.dart';
import 'package:spiral_notebook/services/artifacts_service.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:spiral_notebook/utilities/loading.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';


class CopyArtifactToSharedPortfolioScreen extends ConsumerStatefulWidget {
  const CopyArtifactToSharedPortfolioScreen({
    required this.universalArtifactId,
    this.existingSharedPortfolioId,
    Key? key,
  }) : super(key: key);

  final String universalArtifactId;
  final String? existingSharedPortfolioId;

  @override
  _CopyArtifactToSharedPortfolioScreenState createState() => _CopyArtifactToSharedPortfolioScreenState();
}

class _CopyArtifactToSharedPortfolioScreenState extends ConsumerState<CopyArtifactToSharedPortfolioScreen> {

  // navigation methods
  void closePage() {
    // perform any necessary cleanup before closing this page.
    // .autoDispose will clear the transientResponses.
    // exit to the dashboard
    Navigator.of(context).pop();
  }

  Future<bool> submitCopyTo() async {
    bool cancelAction = false;

      try {
        showLoading(context, 'Saving Changes...');
        final ArtifactsService _artifacts = ArtifactsService();

        Map<String, dynamic> sharedArtifactJson = {};

        switch (currentArtifactOperationType) {

          case ArtifactOperationType.artifact:
            sharedArtifactJson = await _artifacts.copyArtifactToSharedPortfolio(
              sharedPortfolioId: selectedSharedPortfolioId!,
              artifactId: widget.universalArtifactId,
            );
            break;
          case ArtifactOperationType.sharedArtifact:
            sharedArtifactJson = await _artifacts.copySharedArtifactToSharedPortfolio(
              sharedPortfolioId: selectedSharedPortfolioId!,
              sharedArtifactId: widget.universalArtifactId,
            );
            break;
          case ArtifactOperationType.none:
            throw Exception('No artifact operation type declared in CopyArtifactToSharedPortfolioScreen initState!');
        }


        // merge onSubmitSuccess json back into Artifact!
        ref.read(sharedArtifactsProvider.notifier).updateWithSharedArtifactJson(sharedArtifactJson);
        ref.read(sharedPortfoliosProvider.notifier).updateWithSharedArtifactJson(sharedArtifactJson);

        showSnackAlert(context, 'Shared Artifact copied!');

        dismissLoading(context);

        // If they go back, we don't want to see the Copy Artifact page again.
        // Wipe the navigation stack completely, and put the Dashboard on the bottom of the stack
        // so the Shared Artifact page doesn't get confused with the Artifact page.
        Navigator.pushNamedAndRemoveUntil(context, HomeTabsFrame.id, (Route<dynamic> route) => false);

        // Immediately redirect to the new Shared Artifact edit page.
        // NOTE: We are accessing the JSON id inline. This could later be changed
        // if the value needs to be stored as a constant.
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SharedArtifactDetailsScreen(
          sharedArtifactId: '${sharedArtifactJson['id']}',
          sharedPortfolioId: selectedSharedPortfolioId!,
        )));

      } catch (e) {
        Navigator.pop(context);
        if (e is HttpException && e.message.substring(0,3) == "408") {
          // 408 status code is a custom server error.
          // It means the files to process are really big,
          // so the server will need more time to process them
          // before making them available.
          showArtifactProcessingDialog();
          cancelAction = true;
          return cancelAction;
        }
        String message = (e is HttpException)
            ? e.message
            : "Error Copying to Shared Portfolio, please try again.";
        showSnackAlert(context, message);
        cancelAction = true;
        return cancelAction;
      }

    return cancelAction;
  }

  void showArtifactProcessingDialog() {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user can tap anywhere to dismiss
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Shared Artifact Now Processing"),
            content: Text("Artifact shared and will be ready soon. Refresh on dashboard to fetch your latest Shared Artifacts."),
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

  void exitAction() {
    closePage();
  }

  // footer action button handlers
  void rightFooterActionButton() async {

    bool cancelAction = false;

    if (selectedSharedPortfolioId == null) {
      cancelAction = true;
      showSnackAlert(context, 'Please select a shared portfolio to copy to.');
    }
    if (cancelAction) return;

    cancelAction = await submitCopyTo();
    if (cancelAction) return;

    // disable "closing" - now we are navigating to a new page after the copy finishes.
    // closePage();
  }


  late SharedPortfolios currentSharedPortfolios;

  late ArtifactOperationType currentArtifactOperationType;

  String? selectedSharedPortfolioId;

  late String appBarHeadingText;
  late String copyQuestionPromptText;

  @override
  void initState() {
    currentSharedPortfolios = ref.read(sharedPortfoliosProvider);
    currentArtifactOperationType = ref.read(artifactOperationTypeProvider);

    switch (currentArtifactOperationType) {

      case ArtifactOperationType.artifact:
        appBarHeadingText = "Copy Artifact";
        copyQuestionPromptText = "Copy snapshot of individual artifact to:";
        break;
      case ArtifactOperationType.sharedArtifact:
        appBarHeadingText = "Copy Shared Artifact";
        copyQuestionPromptText = "Copy snapshot of individual shared artifact to:";
        break;
      case ArtifactOperationType.none:
        throw Exception('No artifact operation type declared in CopyArtifactToSharedPortfolioScreen initState!');
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
        title: Text(appBarHeadingText),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Stack(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: [
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(top: 18.0,bottom: 12.0),
                            child: Text(copyQuestionPromptText,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: currentSharedPortfolios.portfolios.length,
                            itemBuilder: (context, index) {
                              String sharedPortfolioName = currentSharedPortfolios.namesList[index];
                              String sharedPortfolioId = currentSharedPortfolios.idsList[index];

                              if (sharedPortfolioId == widget.existingSharedPortfolioId) {
                                // "skip" the matching portfolio ID by rendering
                                // an empty box.
                                return SizedBox(width: 1.0);
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio(
                                      value: sharedPortfolioId,
                                      groupValue: selectedSharedPortfolioId,
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedSharedPortfolioId = value;
                                        });
                                      },
                                    ),
                                    Flexible(
                                      // Flexible used to allow long text to wrap
                                      child: GestureDetector(
                                        onTapUp: (details) {
                                          setState(() {
                                            selectedSharedPortfolioId = sharedPortfolioId;
                                          });
                                        },
                                        child: Text(sharedPortfolioName,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                          ),
                        ],
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
                  rightButtonText: 'Complete Copy',
                  showLeftButton: true,
                ),
              ]
          );
        },
      ),
    );
  }
}
