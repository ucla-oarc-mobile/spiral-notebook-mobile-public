import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/models/questions/question.dart';
import 'package:spiral_notebook/models/response/file_responses_transient_editor.dart';

class QuestionFileBase extends ConsumerStatefulWidget {
  const QuestionFileBase({
    required this.question,
    required this.onUpdate,
    Key? key,
  }) : super(key: key);


  final Question question;
  final Function(dynamic, Question) onUpdate;

  @override
  QuestionFileBaseState createState() => QuestionFileBaseState();
}

class QuestionFileBaseState<T extends QuestionFileBase> extends ConsumerState<T> {
  FileResponsesTransientEditor? currentFileResponses;

  Widget questionFileWrapper({required List<Widget> children}) {
    return Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: children,
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    currentFileResponses = ref.read(fileResponsesTransientEditorProvider);
  }

  @override
  Widget build(BuildContext context) {
    return questionFileWrapper(children: []);
  }
}
