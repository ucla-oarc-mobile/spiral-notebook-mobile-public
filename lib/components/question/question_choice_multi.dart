import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/artifact/artifact_data_header.dart';
import 'package:spiral_notebook/components/artifact/artifact_input_multi_select_chip.dart';
import 'package:spiral_notebook/components/artifact_details/artifact_details_bonus_header.dart';
import 'package:spiral_notebook/components/question/question_text_base.dart';
import 'package:spiral_notebook/models/questions/question.dart';

class QuestionChoiceMulti extends QuestionTextBase {
  const QuestionChoiceMulti({
    required this.question,
    required this.onUpdate,
    Key? key,
  }) : super(question: question, onUpdate: onUpdate, key: key);


  final Question question;
  final Function(dynamic, Question) onUpdate;

  @override
  _QuestionChoiceMultiState createState() => _QuestionChoiceMultiState();
}

class _QuestionChoiceMultiState extends QuestionTextBaseState<QuestionChoiceMulti> {
  late Question myQuestion;

  List<String> _initialSelections = [];

  @override
  void initState() {
    super.initState();
    myQuestion = widget.question;

    _initialSelections = (editingMultipleResponses)
        ? currentTextResponses?.getValueByKey(myQuestion.promptKey) ?? []
        : currentTextResponse?.getValue() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return questionTextWrapper(
      // questionGroupWrapper defined in QuestionGroupBase.
        children: [
          // replace with label that includes the subhead.
          (widget.question.isBonus)
              ? ArtifactDetailsBonusHeader(label: myQuestion.label)
              : ArtifactDataHeader(label: myQuestion.label),
          ArtifactInputMultiSelectChip(
            myQuestion.parameters['choices'],
            initialSelections: _initialSelections,
            onSelectionChanged: (selectedList) {
              setState(() {
                (editingMultipleResponses)
                    ? currentTextResponses?.updateValueByKey(myQuestion.promptKey, selectedList)
                    : currentTextResponse?.updateValue(selectedList);
                widget.onUpdate.call(selectedList, myQuestion);
              });
            },
          ),
        ]
    );
  }
}
