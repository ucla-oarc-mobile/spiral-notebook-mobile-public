import 'package:flutter/material.dart';
import 'package:spiral_notebook/components/artifact/artifact_data_header.dart';
import 'package:spiral_notebook/components/artifact/artifact_input_multi_text.dart';
import 'package:spiral_notebook/components/artifact_details/artifact_details_bonus_header.dart';
import 'package:spiral_notebook/components/question/question_text_base.dart';
import 'package:spiral_notebook/models/questions/question.dart';

class QuestionTextLong extends QuestionTextBase {
  const QuestionTextLong({
    required this.question,
    required this.onUpdate,
    Key? key,
  }) : super(question: question, onUpdate: onUpdate, key: key);


  final Question question;
  final Function(dynamic, Question) onUpdate;

  @override
  _QuestionTextLongState createState() => _QuestionTextLongState();
}

class _QuestionTextLongState extends QuestionTextBaseState<QuestionTextLong> {
  late Question myQuestion;

  String? _initialValue;

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
          (widget.question.isBonus)
              ? ArtifactDetailsBonusHeader(label: myQuestion.label)
              : ArtifactDataHeader(label: myQuestion.label),
          ArtifactInputMultiText(
              hintText: "${myQuestion.label}",
              initialValue: _initialValue,
              onChanged: (value) {
                setState(() {
                  (editingMultipleResponses)
                      ? currentTextResponses?.updateValueByKey(myQuestion.promptKey, value)
                      : currentTextResponse?.updateValue(value);
                  widget.onUpdate.call(value, myQuestion);
                });
              }
          ),
        ]
    );
  }
}
