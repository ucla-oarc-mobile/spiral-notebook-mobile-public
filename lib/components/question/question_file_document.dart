
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/artifact/artifact_file_header.dart';
import 'package:spiral_notebook/components/artifact/artifact_input_file_chooser_inline.dart';
import 'package:spiral_notebook/components/question/question_file_base.dart';
import 'package:spiral_notebook/models/questions/question.dart';
import 'package:spiral_notebook/models/response/file_response_base.dart';

class QuestionFileDocument extends QuestionFileBase {
  const QuestionFileDocument({
    required this.question,
    required this.onUpdate,
    Key? key,
  }) : super(question: question, onUpdate: onUpdate, key: key);


  final Question question;
  final Function(dynamic, Question) onUpdate;

  @override
  _QuestionFileDocumentState createState() => _QuestionFileDocumentState();
}

class _QuestionFileDocumentState extends QuestionFileBaseState<QuestionFileDocument> {

  late int documentsLength;

  void onFileUpdateState(Map<String, dynamic> fileUpdates) {
    widget.onUpdate(fileUpdates, widget.question);
    print('onFileUpdateState');
  }

  @override
  void initState() {
    super.initState();

    documentsLength = currentFileResponses?.responseDocumentsAll.length ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return questionFileWrapper(
      // questionGroupWrapper defined in QuestionGroupBase.
        children: [
          ArtifactFileHeader(label: (documentsLength == 1)
              ? '$documentsLength File'
              : '$documentsLength Files'
          ),
          ArtifactInputFileChooserInline(
            fileType: ArtifactFileResponseType.document,
            onFilesChosen: (updatedFiles) {
              setState(() {
                documentsLength = updatedFiles.length;
              });
              onFileUpdateState.call({'updatedFiles': updatedFiles});
            },
            onFileRemoved: (removedFile) {
              setState(() {
                documentsLength -= 1;
              });
              onFileUpdateState.call({'removedFile': removedFile});
            },
          ),
        ]
    );
  }
}
