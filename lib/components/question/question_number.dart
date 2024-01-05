import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/artifact/artifact_data_header.dart';
import 'package:spiral_notebook/components/artifact/artifact_input_number_increment.dart';
import 'package:spiral_notebook/components/artifact_details/artifact_details_bonus_header.dart';
import 'package:spiral_notebook/components/question/question_text_base.dart';
import 'package:spiral_notebook/models/questions/question.dart';

class QuestionNumber extends QuestionTextBase {
  const QuestionNumber({
    required this.question,
    required this.onUpdate,
    Key? key,
  }) : super(question: question, onUpdate: onUpdate, key: key);


  final Question question;
  final Function(dynamic, Question) onUpdate;

  @override
  _QuestionNumberState createState() => _QuestionNumberState();
}

class _QuestionNumberState extends QuestionTextBaseState<QuestionNumber> {
  late Question myQuestion;

  int? _initialValue;

  @override
  void initState() {
    super.initState();
    myQuestion = widget.question;

    _initialValue = (editingMultipleResponses)
        ? currentTextResponses?.getValueByKey(myQuestion.promptKey)
        : currentTextResponse?.getValue();
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
          ArtifactInputNumberIncrement(
            initialValue: (_initialValue == null) ? '' : '$_initialValue',
            onValueChanged: (String value) {
              setState(() {
                int? result = int.tryParse(value);
                if (result == null) {
                  result = 0;
                }
                (editingMultipleResponses)
                    ? currentTextResponses?.updateValueByKey(myQuestion.promptKey, result)
                    : currentTextResponse?.updateValue(result);
                widget.onUpdate.call(result, myQuestion);
              });
            },
          ),
        ]
    );
  }
}
