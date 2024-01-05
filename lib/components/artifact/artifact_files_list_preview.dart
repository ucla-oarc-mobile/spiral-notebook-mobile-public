

import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/artifact/artifact_files_empty.dart';
import 'package:spiral_notebook/models/response/file_response_base.dart';
import 'package:spiral_notebook/models/response/file_response_local.dart';
import 'package:spiral_notebook/models/response/file_response_remote.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtifactFilesListPreview extends StatefulWidget {
  ArtifactFilesListPreview({
    Key? key,
    required this.previewedFileResponses,
    required this.fileType,
    this.onFileRemoved,
  }) : super(key: key);

  //This list should contain either FileResponseRemote or FileResponseLocal.
  final List<dynamic> previewedFileResponses;

  final Function(dynamic)? onFileRemoved;

  final ArtifactFileResponseType fileType;

  @override
  State<ArtifactFilesListPreview> createState() => _ArtifactFilesListPreviewState();
}

class _ArtifactFilesListPreviewState extends State<ArtifactFilesListPreview> {
  late String typeLabel;

  @override
  void initState() {
    super.initState();
    switch (widget.fileType) {
      case ArtifactFileResponseType.document:
        typeLabel = 'Document';
        break;
      case ArtifactFileResponseType.image:
        typeLabel = 'Photo';
        break;
      case ArtifactFileResponseType.video:
        typeLabel = 'Video';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: viewportConstraints.maxWidth,
            ),
            child: Container(
                child: (widget.previewedFileResponses.isEmpty)
                ? ArtifactFilesEmpty(typeLabel: typeLabel)
                : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.previewedFileResponses.length,
                  itemBuilder: (context, index) {
                    final dynamic fileResponse = widget.previewedFileResponses[index];
                    bool isLocal = (fileResponse.runtimeType == FileResponseLocal);
                    FileResponseLocal? fileResponseLocal;
                    FileResponseRemote? fileResponseRemote;

                    (isLocal)
                        ? fileResponseLocal = fileResponse as FileResponseLocal
                        : fileResponseRemote = fileResponse as FileResponseRemote;

                    int bytes = isLocal ? fileResponseLocal!.sizeBytes : fileResponseRemote!.sizeBytes;
                    IconData displayIcon = isLocal ? Icons.file_present : Icons.link;
                    String bytesDisplay = isLocal ? fileResponseLocal!.bytesFormatted : fileResponseRemote!.bytesFormatted;
                    String bytesSuffix = isLocal ? fileResponseLocal!.bytesSuffix : fileResponseRemote!.bytesSuffix;

                    String displayName = isLocal ? fileResponseLocal!.fileNameShortened : fileResponseRemote!.fileNameShortened;

                    return Dismissible(
                        key: Key(isLocal ? fileResponseLocal!.localPath : fileResponseRemote!.linkPath),
                        direction: DismissDirection.endToStart,
                        confirmDismiss:
                            (DismissDirection direction) async {
                          try {
                            await widget.onFileRemoved?.call(widget.previewedFileResponses[index]);
                            showSnackAlert(context, 'File removed!');
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
                        child: GestureDetector(
                          onTapUp: (TapUpDetails details) async {
                            if (!isLocal) {
                              String _url = fileResponseRemote!.linkPath;

                              if (!await launchUrl(Uri.parse(_url))) throw 'Could not launch $_url';}
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 8.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 8.0),
                              color: buttonBGDisabledGrey,
                              child: Row(
                                children:
                                <Widget>[
                                  Icon(displayIcon),
                                  SizedBox(width: 8.0),
                                  Text('$displayName',
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(width: 8.0),
                                  bytes != 0 ? Text('$bytesDisplay') : SizedBox(height: 1.0),
                                  bytes != 0 ? Text('$bytesSuffix') :  SizedBox(height: 1.0),
                                ],
                              ),
                            ),
                          ),
                        )
                    );
                  },
                )
            ),
          );
        }
    );
  }
}
