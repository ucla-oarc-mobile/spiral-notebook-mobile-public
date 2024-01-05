import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/artifact_details/artifact_details_inline_notice.dart';
import 'package:spiral_notebook/models/response/file_response_base.dart';
import 'package:spiral_notebook/models/response/file_response_remote.dart';
import 'package:spiral_notebook/models/response/file_responses_remote.dart';
import 'package:spiral_notebook/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtifactDetailsFilesPreview extends StatelessWidget {
  const ArtifactDetailsFilesPreview({
    Key? key,
    required this.fileResponses,
  }) : super(key: key);

  final FileResponsesRemote fileResponses;


  @override
  Widget build(BuildContext context) {
    List<FileResponseRemote> documentResponses = fileResponses.getResponsesByType(ArtifactFileResponseType.document);
    List<FileResponseRemote> imageResponses = fileResponses.getResponsesByType(ArtifactFileResponseType.image);
    List<FileResponseRemote> videoResponses = fileResponses.getResponsesByType(ArtifactFileResponseType.video);
    // just loop through all the files responses and display them one at a time, in 3 groups.
    // Have three chunks, one each for images, documents and videos.
    // If a chunk is empty, don't display it (for now).
    // use the "thumbnails" for the images collection,
    // and the "list" template for the videos and documents collections.
    return Column(
      children: [
        if (documentResponses.length > 0)
          _ListPreview(label: 'Document', fileResponses: documentResponses),
        if (imageResponses.length > 0)
          _ImagePreview(imageResponses: imageResponses),
        if (videoResponses.length > 0)
        _ListPreview(label: 'Video', fileResponses: videoResponses),
        if (fileResponses.responses.length == 0)
          ArtifactDetailsInlineNotice(label: 'No File Uploads provided.'),
      ],
    );
  }
}


class _ListPreview extends StatelessWidget {
  const _ListPreview({
    Key? key,
    required this.fileResponses,
    required this.label,
  }) : super(key: key);

  final List<FileResponseRemote> fileResponses;
  final String label;

  @override
  Widget build(BuildContext context) {
    final String labelWithLength = (fileResponses.length == 1)
        ? '1 $label'
        : '${fileResponses.length} ${label}s';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ArtifactDetailsInlineNotice(label: labelWithLength),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: fileResponses.length,
          itemBuilder: (context, index) {
            final FileResponseRemote fileResponse = fileResponses[index];
            return GestureDetector(
              onTapUp: (TapUpDetails details) async {
                String _url = fileResponse.linkPath;
                if (Platform.isAndroid && fileResponse.type == ArtifactFileResponseType.document) {
                  if (!await launchUrl(Uri.parse(_url),
                      mode: LaunchMode.externalApplication)) throw 'Could not launch $_url';
                } else {
                  if (!await launchUrl(Uri.parse(_url))) throw 'Could not launch $_url';
                }
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
                      Icon(Icons.link),
                      SizedBox(width: 8.0),
                      if (fileResponse.namePrefix != '')
                        Text("${fileResponse.namePrefix}.",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      if (fileResponse.namePrefix != '')
                        SizedBox(width: 4.0),
                      Text(fileResponse.fileNameShortened,
                          style: TextStyle(fontWeight: FontWeight.normal)),
                      SizedBox(width: 8.0),
                      fileResponse.sizeBytes != 0 ? Text(fileResponse.bytesFormatted) : SizedBox(height: 1.0),
                      fileResponse.sizeBytes != 0 ? Text(fileResponse.bytesSuffix) :  SizedBox(height: 1.0),
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({
    Key? key,
    required this.imageResponses,
  }) : super(key: key);

  final List<FileResponseRemote> imageResponses;

  @override
  Widget build(BuildContext context) {
    final String labelWithLength = (imageResponses.length == 1)
        ? '1 Image'
        : '${imageResponses.length} Images';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ArtifactDetailsInlineNotice(label: labelWithLength),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: imageResponses.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (context, index) {
            final FileResponseRemote imageResponse = imageResponses[index];
            return Column(
              children: [
                Expanded(
                  child: Container(
                      color: buttonBGDisabledGrey,
                      // TODO: Add conditional split - if Local or Remote image file
                      child: GestureDetector(
                        onTapUp: (TapUpDetails details) async {
                          String _url = imageResponse.linkPath;
                          // if (Platform.isAndroid) {
                          //   if (!await launchUrl(Uri.parse(_url),
                          //       mode: LaunchMode.externalApplication)) throw 'Could not launch $_url';
                          // } else {
                          //   if (!await launchUrl(Uri.parse(_url))) throw 'Could not launch $_url';
                          // }
                          if (!await launchUrl(Uri.parse(_url))) throw 'Could not launch $_url';
                        },
                        child: Stack(
                          children: [
                            Center(
                              child: Image.network(
                                imageResponse.imageMediumPath,
                                fit: BoxFit.fitWidth,
                              ),
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
                      )),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (imageResponse.namePrefix != '')
                      Text("${imageResponse.namePrefix}.",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    if (imageResponse.namePrefix != '')
                      SizedBox(width: 4.0),
                    Text(imageResponse.fileNameExtraShortened,
                        style: TextStyle(fontWeight: FontWeight.normal)),
                  ],
                )
              ],
            );
          },
        ),
      ],
    );
  }
}