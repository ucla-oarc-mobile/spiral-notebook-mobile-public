import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/artifact/artifact_data_header.dart';
import 'package:spiral_notebook/components/artifact/artifact_input_segmented_single_selector.dart';
import 'package:spiral_notebook/components/artifact_details/artifact_details_bonus_header.dart';
import 'package:spiral_notebook/components/question/question_text_base.dart';
import 'package:spiral_notebook/models/questions/question.dart';

class QuestionChoiceSingle extends QuestionTextBase {
  const QuestionChoiceSingle({
    required this.question,
    required this.onUpdate,
    Key? key,
  }) : super(question: question, onUpdate: onUpdate, key: key);


  final Question question;
  final Function(dynamic, Question) onUpdate;

  @override
  _QuestionChoiceSingleState createState() => _QuestionChoiceSingleState();
}

class _QuestionChoiceSingleState extends QuestionTextBaseState<QuestionChoiceSingle> {
  late Question myQuestion;

  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    myQuestion = widget.question;

    _selectedValue = (editingMultipleResponses)
        ? currentTextResponses?.getValueByKey(myQuestion.promptKey)
        : currentTextResponse?.getValue();
  }

  @override
  Widget build(BuildContext context) {
    return questionTextWrapper(
      // questionGroupWrapper defined in QuestionGroupBase.
        children: [
          (widget.question.isBonus)
              ? ArtifactDetailsBonusHeader(label: myQuestion.label)
              : ArtifactDataHeader(label: myQuestion.label),
          ArtifactInputSegmentedSingleSelector(
            options: myQuestion.parameters['choices'],
            onValueChanged: (String value) {
              setState(() {
                (editingMultipleResponses)
                    ? currentTextResponses?.updateValueByKey(myQuestion.promptKey, value)
                    : currentTextResponse?.updateValue(value);
                _selectedValue = value;
                widget.onUpdate.call(value, myQuestion);
              });
            },
            selectedValue: _selectedValue,
          ),
        ]
    );
  }
}
