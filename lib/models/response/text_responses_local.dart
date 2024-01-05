import 'package:spiral_notebook/models/questions/question.dart';
import 'package:spiral_notebook/models/questions/questions.dart';
import 'package:spiral_notebook/models/response/text_response_base.dart';
import 'package:spiral_notebook/models/response/text_responses.dart';

class TextResponsesLocal extends TextResponses {
  TextResponsesLocal() : super({});

  static Map<String, TextResponseBase> responsesFromQuestions({required Questions myQuestions, Map<String, dynamic>? initialValues}) {
    Map<String, TextResponseBase> result = {};

    initialValues = initialValues ?? {};

    myQuestions.questions.forEach((question) {

      if (question.type != QuestionType.files) {
        // only add non-file questions to this!
        final dynamic initialValue = initialValues![question.promptKey];
        (initialValue != null)
            ? result[question.promptKey] = TextResponseBase.fromValue(value: initialValue, type: question.type, promptKey: question.promptKey)
            : result[question.promptKey] = TextResponseBase(type: question.type, promptKey: question.promptKey);
      }
    });

    return result;
  }

  TextResponsesLocal.fromQuestions({required Questions questions, Map<String, dynamic>? initialValues})
      : super(responsesFromQuestions(myQuestions: questions, initialValues: initialValues));
}