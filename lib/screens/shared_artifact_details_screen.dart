import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/artifact/artifact_floating_footer.dart';
import 'package:spiral_notebook/components/artifact_details/artifact_details_builder.dart';
import 'package:spiral_notebook/components/common/universal_artifact_details_metadata.dart';
import 'package:spiral_notebook/components/common/inline_section_header.dart';
import 'package:spiral_notebook/models/questions/questions.dart';
import 'package:spiral_notebook/models/shared_artifact/shared_artifact.dart';
import 'package:spiral_notebook/models/shared_artifact/shared_artifacts.dart';
import 'package:spiral_notebook/providers/artifact_operations_provider.dart';
import 'package:spiral_notebook/providers/shared_artifacts_provider.dart';
import 'package:spiral_notebook/providers/shared_portfolios_provider.dart';
import 'package:spiral_notebook/screens/copy_artifact_to_shared_portfolio_screen.dart';
import 'package:spiral_notebook/screens/edit_artifact_screen.dart';
import 'package:spiral_notebook/screens/home_tabs_frame.dart';
import 'package:spiral_notebook/screens/shared_artifact_comments_screen.dart';
import 'package:spiral_notebook/services/shared_artifacts_service.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:spiral_notebook/utilities/loading.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';

final sharedArtifactDetailProvider = Provider.family<SharedArtifact, String>((ref, artifactId) {

  final SharedArtifacts sharedArtifacts = ref.watch(sharedArtifactsProvider);
  final int indexFound = sharedArtifacts.artifacts.indexWhere((artifact) => artifact.id == artifactId);
  assert(indexFound != -1);

  return sharedArtifacts.artifacts[indexFound];
});

class SharedArtifactDetailsScreen extends ConsumerStatefulWidget {
  const SharedArtifactDetailsScreen({
    required this.sharedPortfolioId,
    required this.sharedArtifactId,
    Key? key,
  }) : super(key: key);

  final String sharedPortfolioId;
  final String sharedArtifactId;


  @override
  _SharedArtifactDetailsScreenState createState() => _SharedArtifactDetailsScreenState();
}

class _SharedArtifactDetailsScreenState extends ConsumerState<SharedArtifactDetailsScreen> {

  // tracking questions
  late Questions currentQuestions;

  late SharedArtifact singleSharedArtifact;

  late bool isComplete = false;

  @override
  void initState() {
    super.initState();
    singleSharedArtifact = ref.read(sharedArtifactDetailProvider(widget.sharedArtifactId));
    currentQuestions = Questions.fromUniversalArtifact(singleSharedArtifact.structure, widget.sharedArtifactId);
  }

  @override
  Widget build(BuildContext context) {
    singleSharedArtifact = ref.watch(sharedArtifactDetailProvider(widget.sharedArtifactId));
    currentQuestions = Questions.fromUniversalArtifact(singleSharedArtifact.structure, widget.sharedArtifactId);

    Future<void> showComments() async {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SharedArtifactCommentsScreen(
        sharedArtifactId: singleSharedArtifact.id,
      )));
    }

    Future<bool> deleteSharedArtifact() async {

      bool cancelAction = false;

      try {
        showLoading(context, 'Deleting Artifact...');
        final SharedArtifactsService _artifacts = SharedArtifactsService();

        Map<String, dynamic> artifactJson = await _artifacts.deleteSharedArtifact(
          artifactId: widget.sharedArtifactId,
        );

        print(artifactJson);
        dismissLoading(context);

        // Navigate, THEN remove the artifact ID, since removing it
        // while on the artifact page could cause an error.
        Navigator.pushNamedAndRemoveUntil(context, HomeTabsFrame.id, (Route<dynamic> route) => false);

        Future.delayed(Duration(milliseconds: 250), () {
          // delay for navigation to complete before removing this artifact
          // from the app's local data store.
          ref.read(sharedArtifactsProvider.notifier).updateWithRemovedSharedArtifactId(widget.sharedArtifactId);
          ref.read(sharedPortfoliosProvider.notifier).updateWithRemovedSharedArtifactId(
            sharedArtifactId: widget.sharedArtifactId,
            sharedPortfolioId: widget.sharedPortfolioId,
          );
          showSnackAlert(context, 'Shared artifact deleted!');
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
              title: Text("Delete Shared Artifact"),
              content: Text("Are you sure that you want to delete this shared artifact? It can't be recovered."),
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
                      bool cancelAction = await deleteSharedArtifact();
                      if (cancelAction) return;
                    }),
              ],
            );
          });
    }

    void launchSharedCopyTo(TapUpDetails details) {
      ref.read(artifactOperationTypeProvider.notifier).state = ArtifactOperationType.sharedArtifact;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CopyArtifactToSharedPortfolioScreen(
            universalArtifactId: singleSharedArtifact.id,
            existingSharedPortfolioId: widget.sharedPortfolioId,
          )));
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
        title: Text('Shared Artifact'.toUpperCase()),
        backgroundColor: primaryButtonBlue,
        actions: <Widget>[
          IconButton(
            tooltip: 'Delete Shared Artifact',
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
                            InlineSectionHeader(label: singleSharedArtifact.name),
                            UniversalArtifactDetailsMetadata(universalArtifact: singleSharedArtifact),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTapUp: launchSharedCopyTo,
                                  child: Text('Copy Snapshot to New Shared Portfolio...', style: TextStyle(color: primaryButtonBlue))
                              ),
                            ),
                            SizedBox(height: 8),
                            ...currentQuestions.questions.map((question) => ArtifactDetailsBuilder(
                              question: question,
                              onTapEdit: () {
                                // call the edit method for this particular promptKey

                                // Set our current artifact operation mode to "Edit"
                                // so our Question components access the appropriate Response Provider.
                                ref.read(artifactOperationModeProvider.notifier).state = ArtifactOperationMode.edit;
                                ref.read(artifactOperationTypeProvider.notifier).state = ArtifactOperationType.sharedArtifact;
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditArtifactScreen(
                                  universalPortfolioId: singleSharedArtifact.sharedPortfolioId,
                                  universalArtifactId: singleSharedArtifact.id,
                                  artifactDateModified: singleSharedArtifact.dateModified,
                                  fileType: singleSharedArtifact.modifyFileType,
                                  promptKey: question.promptKey,
                                )));
                              },
                              fileResponses: singleSharedArtifact.fileResponses,
                              textResponse: singleSharedArtifact.textResponsesRemote.getValueByKey(question.promptKey),
                            )).toList(),
                            SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ArtifactFloatingFooter(
                    enableButtons: true,
                    maxWidth: viewportConstraints.maxWidth,
                    onRightTapUp: showComments,
                    rightButtonText: 'Comments',
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




