import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/question/question_choice_expansion_panel.dart';
import 'package:spiral_notebook/components/question/question_choice_multi.dart';
import 'package:spiral_notebook/components/question/question_choice_single.dart';
import 'package:spiral_notebook/components/question/question_file_document.dart';
import 'package:spiral_notebook/components/question/question_file_media.dart';
import 'package:spiral_notebook/components/question/question_number.dart';
import 'package:spiral_notebook/components/question/question_text_long.dart';
import 'package:spiral_notebook/components/question/question_text_short.dart';
import 'package:spiral_notebook/models/questions/question.dart';
import 'package:spiral_notebook/providers/artifact_operations_provider.dart';

class QuestionBuilder extends ConsumerStatefulWidget {
  const QuestionBuilder({
    required this.question,
    required this.onUpdate,
    required this.fileType,
    Key? key,
  }) : super(key: key);

  final Question question;
  final Function(dynamic, Question) onUpdate;
  final ModifyArtifactFileType fileType;

  @override
  _QuestionBuilderState createState() => _QuestionBuilderState();
}

class _QuestionBuilderState extends ConsumerState<QuestionBuilder> {


  Widget getWidgetGroup(ModifyArtifactFileType myFileType) {

    Map<QuestionType, Widget> typeToWidgetGroup = {
      QuestionType.files:
      (myFileType == ModifyArtifactFileType.document)
          ? QuestionFileDocument(question: widget.question, onUpdate: widget.onUpdate)
          : QuestionFileMedia(question: widget.question, onUpdate: widget.onUpdate),
      QuestionType.number:
      QuestionNumber(question: widget.question, onUpdate: widget.onUpdate),
      QuestionType.shortText:
      QuestionTextShort(question: widget.question, onUpdate: widget.onUpdate),
      QuestionType.longText:
      QuestionTextLong(question: widget.question, onUpdate: widget.onUpdate),
      QuestionType.singleChoice:
      QuestionChoiceSingle(question: widget.question, onUpdate: widget.onUpdate),
      QuestionType.multiChoice:
      QuestionChoiceMulti(question: widget.question, onUpdate: widget.onUpdate),
      QuestionType.expansionPanelChoices:
      QuestionChoiceExpansionPanel(question: widget.question, onUpdate: widget.onUpdate),
    };

    final Widget? myGroup = typeToWidgetGroup[widget.question.type] ?? typeToWidgetGroup[QuestionType.shortText];

    // assert(myGroup != null);

    return myGroup!;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return getWidgetGroup(widget.fileType);
    });
  }
}
