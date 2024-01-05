
import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/artifact/artifact_file_header.dart';
import 'package:spiral_notebook/components/artifact/artifact_input_file_chooser_inline.dart';
import 'package:spiral_notebook/components/question/question_file_base.dart';
import 'package:spiral_notebook/models/questions/question.dart';
import 'package:spiral_notebook/models/response/file_response_base.dart';

class QuestionFileMedia extends QuestionFileBase {
  const QuestionFileMedia({
    required this.question,
    required this.onUpdate,
    Key? key,
  }) : super(question: question, onUpdate: onUpdate, key: key);


  final Question question;
  final Function(dynamic, Question) onUpdate;

  @override
  _QuestionFileMediaState createState() => _QuestionFileMediaState();
}

class _QuestionFileMediaState extends QuestionFileBaseState<QuestionFileMedia> {

  late int imagesLength;
  late int videosLength;

  void onFileUpdateState(Map<String, dynamic> fileUpdates) {
    widget.onUpdate(fileUpdates, widget.question);
    print('onFileUpdateState');
  }

  @override
  void initState() {
    super.initState();

    imagesLength = currentFileResponses?.responseImagesAll.length ?? 0;
    videosLength = currentFileResponses?.responseVideosAll.length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return questionFileWrapper(
      // questionGroupWrapper defined in QuestionGroupBase.
        children: [
          ArtifactFileHeader(label: (imagesLength == 1)
              ? '$imagesLength Image'
              : '$imagesLength Images'
          ),
          ArtifactInputFileChooserInline(
            fileType: ArtifactFileResponseType.image,
            onFilesChosen: (List<dynamic> updatedFiles) {
              setState(() {
                imagesLength = updatedFiles.length;
              });
              onFileUpdateState.call({'updatedFiles': updatedFiles});
            },
            onFileRemoved: (dynamic removedFile) {
              setState(() {
                imagesLength -= 1;
              });

              onFileUpdateState.call({'removedFile': removedFile});
            },
          ),
          Divider(thickness: 2.0),
          ArtifactFileHeader(label: (videosLength == 1)
              ? '$videosLength Video'
              : '$videosLength Videos'
          ),
          ArtifactInputFileChooserInline(
            fileType: ArtifactFileResponseType.video,
            onFilesChosen: (List<dynamic> updatedFiles) {
              setState(() {
                videosLength = updatedFiles.length;
              });
              onFileUpdateState.call({'updatedFiles': updatedFiles});
            },
            onFileRemoved: (dynamic removedFile) {
              setState(() {
                videosLength -= 1;
              });
              onFileUpdateState.call({'removedFile': removedFile});
            },
          ),
        ]
    );
  }
}

