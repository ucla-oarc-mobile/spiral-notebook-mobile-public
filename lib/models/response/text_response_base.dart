import 'package:spiral_notebook/models/questions/question.dart';

enum TextResponseType {
  choices,
  int,
  string,
}

const Map<QuestionType, TextResponseType>questionTypeTextResponseTypeMap = {
  QuestionType.longText: TextResponseType.string,
  QuestionType.multiChoice: TextResponseType.choices,
  QuestionType.number: TextResponseType.int,
  QuestionType.singleChoice: TextResponseType.string,
  QuestionType.shortText: TextResponseType.string,
  QuestionType.expansionPanelChoices: TextResponseType.choices,
};

class TextResponseBase {
  final String promptKey;
  final QuestionType type;

  // At higher levels, we don't interact
  // with TextResponseBase directly.
  // To ensure type protection (since a
  // given Response can be one of three types),
  // the value is only accessed via getters
  // and setters. The actual value is stored
  // inside of a private map with ResponseKeys
  // linked to the `responseType` property.
  Map<TextResponseType, dynamic> _value = {};

  final TextResponseType responseType;

  List<String>? get valueChoices =>_value[TextResponseType.choices];
  int? get valueInt =>_value[TextResponseType.int];
  String? get valueString =>_value[TextResponseType.string];

  dynamic get valueDynamic {
    dynamic result;

    switch (responseType) {

      case TextResponseType.choices:
        result = valueChoices;
        break;
      case TextResponseType.int:
        result = valueInt;
        break;
      case TextResponseType.string:
        result = valueString;
        break;
    }

    return result;
  }

  set valueChoices(List<String>? response) => this._value[TextResponseType.choices] = response;
  set valueInt(int? response) => this._value[TextResponseType.int] = response;
  set valueString(String? response) => this._value[TextResponseType.string] = response;

  set valueDynamic(dynamic value) {
    switch (responseType) {
      case TextResponseType.choices:
        valueChoices = value;
        break;
      case TextResponseType.int:
        valueInt = value;
        break;
      case TextResponseType.string:
        valueString = value;
        break;
    }
  }

  static TextResponseType assignResponseType(QuestionType qType) {

    TextResponseType rType;

    rType = questionTypeTextResponseTypeMap[qType]!;

    return rType;
  }

  static Map<TextResponseType, dynamic> assignValue(dynamic myResponse, TextResponseType rType) {
    Map<TextResponseType, dynamic> result = {};

    if (myResponse == null) {
      // abandon type conversion, just set it to null!
      result[rType] = null;
      return result;
    }

    switch (rType) {
      // Intense type conversion required!
      // turn incoming dynamic values into typed ones.
      // Essentially this turns a List<dynamic> into a List<String>

      case TextResponseType.choices:
        result[rType] = List<String>.from(
            (myResponse as List).map((value) => '$value').toList()
        );
        break;
      case TextResponseType.int:
        result[rType] = myResponse as int;
        break;
      case TextResponseType.string:
        result[rType] = myResponse as String;
        break;
    }

    return result;
  }

  TextResponseBase({
    required this.promptKey,
    required this.type,
  }) : responseType = assignResponseType(type);

  TextResponseBase.fromValue({required dynamic value, required QuestionType type, required String promptKey})
    : promptKey = promptKey,
      type = type,
        responseType = assignResponseType(type),
      _value = assignValue(value, assignResponseType(type));


}