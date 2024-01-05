

import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/artifact/artifact_files_empty.dart';
import 'package:spiral_notebook/models/response/file_response_local.dart';
import 'package:spiral_notebook/models/response/file_response_remote.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtifactFilesImagesPreview extends StatefulWidget {
  ArtifactFilesImagesPreview({
    Key? key,
    required this.previewedFileResponses,
    this.onFileRemoved,
  }) : super(key: key);

  //This list should contain either FileResponseRemote or FileResponseLocal.
  final List<dynamic> previewedFileResponses;


  final Function(dynamic)? onFileRemoved;

  @override
  State<ArtifactFilesImagesPreview> createState() => _ArtifactFilesImagesPreviewState();
}

class _ArtifactFilesImagesPreviewState extends State<ArtifactFilesImagesPreview> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: viewportConstraints.maxWidth,
            ),
            child: Container(
                padding: EdgeInsets.all(10.0),
                child: (widget.previewedFileResponses.isEmpty)
                    ? ArtifactFilesEmpty(typeLabel: "Image")
                    : GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.previewedFileResponses.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final dynamic fileResponse = widget.previewedFileResponses[index];
                    bool isLocal = (fileResponse.runtimeType == FileResponseLocal);
                    FileResponseLocal? fileResponseLocal;
                    FileResponseRemote? fileResponseRemote;

                    (isLocal)
                        ? fileResponseLocal = fileResponse as FileResponseLocal
                        : fileResponseRemote = fileResponse as FileResponseRemote;

                    return Dismissible(
                      key: Key(isLocal ? fileResponseLocal!.localPath : fileResponseRemote!.linkPath),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (DismissDirection direction) async {
                        try {
                          await widget.onFileRemoved?.call(widget.previewedFileResponses[index]);
                          showSnackAlert(context, 'Image removed!');
                          setState(() {
                            widget.previewedFileResponses.removeAt(index);
                          });
                          return true;
                        } catch (e) {
                          return false;
                        }
                      },
                      // Show a red background as the item is swiped away.
                      background: Container(
                        alignment: Alignment(0.95, 0.0),
                        color: Colors.red,
                        child: Icon(
                          Icons.delete,
                          color: buttonBorderGrey,
                        ),
                      ),
                      child: Container(
                        child: Container(
                          color: buttonBGDisabledGrey,
                          child: (isLocal)
                              ? Stack(
                            children: [
                              Image.file(
                                fileResponseLocal!.value,
                                fit: BoxFit.fitWidth,
                              ),
                              Positioned(
                                  bottom: 8.0,
                                  right: 8.0,
                                  child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: interfaceButtonBlue,
                                        borderRadius: BorderRadius.circular(25.0),
                                        border: Border.all(color: Colors.white, width: 1.0),
                                      ),
                                      child: Icon(Icons.file_present, color: Colors.white))),
                            ],
                          )
                              : GestureDetector(
                            onTapUp: (TapUpDetails details) async {
                              if (!isLocal) {
                                String _url = fileResponseRemote!.linkPath;
                                if (!await launchUrl(Uri.parse(_url))) throw 'Could not launch $_url';
                              }
                            },
                            child: Stack(
                              children: [
                                Image.network(
                                  fileResponseRemote!.imageThumbnailPath,
                                  fit: BoxFit.fitWidth,
                                ),
                                Positioned(
                                    bottom: 8.0,
                                    right: 8.0,
                                    child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: interfaceButtonBlue,
                                          borderRadius: BorderRadius.circular(25.0),
                                          border: Border.all(color: Colors.white, width: 1.0),
                                        ),
                                        child: Icon(Icons.link, color: Colors.white))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
            ),
          );
        }
    );
  }
}
