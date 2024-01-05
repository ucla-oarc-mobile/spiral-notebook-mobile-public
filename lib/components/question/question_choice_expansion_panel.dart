import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/artifact/artifact_data_header.dart';
import 'package:spiral_notebook/components/artifact/artifact_input_expansion_panel_choices.dart';
import 'package:spiral_notebook/components/artifact_details/artifact_details_bonus_header.dart';
import 'package:spiral_notebook/components/question/question_text_base.dart';
import 'package:spiral_notebook/models/questions/question.dart';

class QuestionChoiceExpansionPanel extends QuestionTextBase {
  const QuestionChoiceExpansionPanel({
    required this.question,
    required this.onUpdate,
    Key? key,
  }) : super(question: question, onUpdate: onUpdate, key: key);


  final Question question;
  final Function(dynamic, Question) onUpdate;

  @override
  _QuestionChoiceExpansionPanelState createState() => _QuestionChoiceExpansionPanelState();
}

class _QuestionChoiceExpansionPanelState extends QuestionTextBaseState<QuestionChoiceExpansionPanel> {
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
          (widget.question.isBonus)
              ? ArtifactDetailsBonusHeader(label: myQuestion.label)
              : ArtifactDataHeader(label: myQuestion.label),
          ArtifactInputExpansionPanelChoices(
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
