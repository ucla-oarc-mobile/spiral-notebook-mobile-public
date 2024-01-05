import 'package:spiral_notebook/models/questions/question.dart';
import 'package:spiral_notebook/models/response/text_response_base.dart';

Map <QuestionType, Function(TextResponseBase, String)> textResponseValidators = {
  QuestionType.longText: (response, questionErrorLabel) {
    if (response.valueString == null || response.valueString!.isEmpty)
      throw FormatException('Please enter response for "$questionErrorLabel."');
  },
  QuestionType.multiChoice: (response, questionErrorLabel) {
    if (response.valueChoices == null || response.valueChoices!.isEmpty)
      throw FormatException('Please select option for "$questionErrorLabel."');
  },
  QuestionType.number: (response, questionErrorLabel) {
    if (response.valueInt == null)
      throw FormatException('Please enter response for "$questionErrorLabel."');
  },
  QuestionType.singleChoice: (response, questionErrorLabel) {
    if (response.valueString == null || response.valueString!.isEmpty)
      throw FormatException('Please select option for "$questionErrorLabel."');
  },
  QuestionType.shortText: (response, questionErrorLabel) {
    if (response.valueString == null || response.valueString!.isEmpty)
      throw FormatException('Please enter response for "$questionErrorLabel."');
  },
  QuestionType.expansionPanelChoices: (response, questionErrorLabel) {
    if (response.valueChoices == null || response.valueChoices!.isEmpty)
      throw FormatException('Please select option for "$questionErrorLabel."');
  },
};