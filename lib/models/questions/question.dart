import 'package:spiral_notebook/api/api_constants.dart';
import 'package:spiral_notebook/models/questions/question_choice_single_option.dart';

enum QuestionType {
  files,
  number,
  shortText,
  longText,
  singleChoice,
  multiChoice,
  expansionPanelChoices,
}

class Question {
  final String label;
  final int pageIndex;
  final String promptKey;
  final QuestionType type;
  final bool isRequired;
  final bool isBonus;

  dynamic initialValue;

  late Map<String, dynamic> parameters;

  
  Question({
    required this.initialValue,
    required this.isBonus,
    required this.isRequired,
    required this.label,
    required this.pageIndex,
    required this.promptKey,
    required this.type,
  });

  static QuestionType assignType(String typeMap) {

    assert(apiPromptKeyTypeMap.containsKey(typeMap));

    return apiPromptKeyTypeMap[typeMap]!;
  }

  static Map<String, dynamic> assignParameters(QuestionType type, Map<String, dynamic> structureJson) {
    Map<String, dynamic> params = {};

    switch (type) {
      case QuestionType.number:
        ['min','max','step'].forEach((parameterKey) {
          assert(structureJson.containsKey(parameterKey));
          params[parameterKey] = structureJson[parameterKey];
        });
        break;
      case QuestionType.singleChoice:
        assert(structureJson.containsKey('choices'));
        params['choices'] = List<QuestionChoiceSingleOption>.from(
            ((structureJson['choices'] as List).map((choice) =>
            QuestionChoiceSingleOption(key: choice, label: choice)).toList())
        );
        break;
      case QuestionType.expansionPanelChoices:
      case QuestionType.multiChoice:
        assert(structureJson.containsKey('choices'));
        params['choices'] = List<String>.from(
            (structureJson['choices'] as List).map((choice) => choice).toList()
        );
        break;
      default:
        break;
    }
    return params;
  }

  Question.fromStructure(Map<String, dynamic> structureJson, int pageIndex)
    : label = '${structureJson['text']}',
      isBonus = (structureJson['bonus'] == true),
      isRequired = (structureJson['core'] == true),
      pageIndex = pageIndex,
      promptKey = '${structureJson['key']}',
      type = assignType(structureJson[questionParamTypeKey]) {
      parameters = assignParameters(type, structureJson);
  }
}