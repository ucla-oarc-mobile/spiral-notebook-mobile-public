import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/models/questions/question.dart';
import 'package:spiral_notebook/models/response/text_responses_transient_multi_editor.dart';
import 'package:spiral_notebook/models/response/text_responses_transient_single_editor.dart';
import 'package:spiral_notebook/providers/artifact_operations_provider.dart';

class QuestionTextBase extends ConsumerStatefulWidget {
  const QuestionTextBase({
    required this.question,
    required this.onUpdate,
    Key? key,
  }) : super(key: key);


  final Question question;
  final Function(dynamic, Question) onUpdate;

  @override
  QuestionTextBaseState createState() => QuestionTextBaseState();
}

class QuestionTextBaseState<T extends QuestionTextBase> extends ConsumerState<T> {
  TextResponsesTransientMultiEditor? currentTextResponses;
  TextResponseTransientSingleEditor? currentTextResponse;

  Widget questionTextWrapper({required List<Widget> children}) {
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

  late bool editingMultipleResponses;

  @override
  void initState() {
    super.initState();

    ArtifactOperationMode currentMode = ref.read(artifactOperationModeProvider);

    editingMultipleResponses = (currentMode == ArtifactOperationMode.add);

    (editingMultipleResponses)
      ? currentTextResponses = ref.read(textResponsesTransientMultiEditorProvider)
        : currentTextResponse = ref.read(textResponsesTransientSingleEditorProvider);
  }

  @override
  Widget build(BuildContext context) {
    return questionTextWrapper(children: []);
  }
}
