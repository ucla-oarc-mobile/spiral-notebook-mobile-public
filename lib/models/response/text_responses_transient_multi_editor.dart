
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/api/api_constants.dart';
import 'package:spiral_notebook/models/questions/question.dart';
import 'package:spiral_notebook/models/questions/questions.dart';
import 'package:spiral_notebook/models/response/text_response_base.dart';
import 'package:spiral_notebook/models/response/text_response_validators.dart';
import 'package:spiral_notebook/models/response/text_responses_local.dart';

class TextResponsesTransientMultiEditor extends TextResponsesLocal {
  TextResponsesTransientMultiEditor() : super();

  // This is a transient responses collection that is generated
  // when multiple artifact items are edited. On top of TextResponsesLocal,
  // it provides an interface for performing multiple operations
  // on responses that are grouped by page:
  // - tracking which responses have been synced
  // - validating responses
  // - querying for responses
  // - getting a bundle of response values ready to submit

  // responsePages is a lookup for response
  // pageIndex values
  Map<String, int> _responsePages = {};

  // track which responses have been synced
  // with the server.
  Set<String> _responseKeysSynced = {};

  // Copy of Questions list, used by validator
  Questions? _questions;

  bool get isFirstSynced => _responseKeysSynced.isNotEmpty;

  @override
  void updateValueByKey(String promptKey, dynamic value) {
    super.updateValueByKey(promptKey, value);

    if (_responseKeysSynced.contains(promptKey))
      // it was updated - so remove it from the synced list.
      _responseKeysSynced.remove(promptKey);
  }

  Map<String, TextResponseBase> getResponsesByPage(int pageIndex) {
    Map<String, TextResponseBase> result = {};

    _responsePages.forEach((promptKey, responseIndex) {
      assert(responses.containsKey(promptKey));
      if (responseIndex == pageIndex)
        result[promptKey] = responses[promptKey]!;
    });

    return result;
  }

  Map<String, TextResponseBase> _getUnsyncedResponsesOnPage(int pageIndex) {
    Map<String, TextResponseBase> result = {};

    _responsePages.forEach((promptKey, responseIndex) {
      assert(responses.containsKey(promptKey));

      if (responseIndex == pageIndex && !_responseKeysSynced.contains(promptKey))
        result[promptKey] = responses[promptKey]!;
    });
    return result;
  }

  bool isPageUnsynced(int pageIndex) => _getUnsyncedResponsesOnPage(pageIndex).isNotEmpty;

  void markSyncedResponsesOnPage(int pageIndex) {
    // should only be done after submit success.

    _responsePages.forEach((promptKey, responseIndex) {
      assert(responses.containsKey(promptKey));

      if (responseIndex == pageIndex && !_responseKeysSynced.contains(promptKey))
        _responseKeysSynced.add(promptKey);
    });
  }

  void validateResponsesOnPage(int pageIndex) {
    Map<String, TextResponseBase> result = getResponsesByPage(pageIndex);

    const maxErrorLabelLength = 20;
    if (result.isEmpty) return;

    result.forEach((promptKey, response) {
      Question? myQuestion = _questions!.questionByKey(promptKey);
      assert(myQuestion != null);
      String questionErrorLabel = (myQuestion!.label.length > maxErrorLabelLength)
          ? myQuestion.label.substring(0, maxErrorLabelLength - 1) + "…"
          : myQuestion.label;
      assert(textResponseValidators.containsKey(response.type));

      if (_responsePages[promptKey] == pageIndex && myQuestion.isRequired)
        textResponseValidators[response.type]!.call(response, questionErrorLabel);
    });
  }

  Map<String, dynamic> getSubmitPayload(int pageIndex, bool inParkingLot) {
    Map<String, dynamic> result = {};

    Map<String, TextResponseBase> payloadResponses = _getUnsyncedResponsesOnPage(pageIndex);

    assert(payloadResponses.isNotEmpty);

    Map<String, dynamic> responseJson = {};

    payloadResponses.forEach((promptKey, response) {
      responseJson[promptKey] = getValueByKey(promptKey);
    });

    result[artifactParamResponsesKey] = responseJson;

    // apply flag for adding to parking lot
    result[artifactParamParkingLotFlag] = inParkingLot;

    if (_responseKeysSynced.isEmpty)
      // no responses have been uploaded yet, so upload the structure too.
      result[artifactParamQuestionStructureKey] = _questions!.structure;

    return result;
  }

  static Map<String, int> responsePagesFromQuestions(Questions myQuestions) {
    Map<String, int> result = {};

    myQuestions.questions.forEach((question) {
      if (question.type != QuestionType.files)
        // only add non-file questions to this!
        result[question.promptKey] = question.pageIndex;
    });

    return result;
  }

  TextResponsesTransientMultiEditor.fromQuestions({required Questions questions, Map<String, dynamic>? initialValues})
      : _questions = questions,
        _responsePages = responsePagesFromQuestions(questions),
        super.fromQuestions(questions: questions, initialValues: initialValues);
}


class TextResponsesTransientMultiEditorManager extends StateNotifier<TextResponsesTransientMultiEditor> {

  TextResponsesTransientMultiEditorManager() : super(TextResponsesTransientMultiEditor());

  void initWithQuestions(Questions questions) {
    state = TextResponsesTransientMultiEditor.fromQuestions(questions: questions);
  }

  void initWithResponses({required Questions questions, Map<String, dynamic>? initialValues}) {
    state = TextResponsesTransientMultiEditor.fromQuestions(questions: questions, initialValues: initialValues);
  }

  void reset() {
    state = TextResponsesTransientMultiEditor();
  }

}

final textResponsesTransientMultiEditorProvider = StateNotifierProvider.autoDispose<TextResponsesTransientMultiEditorManager, TextResponsesTransientMultiEditor>(
        (ref) {
      //.autoDispose and `maintainState = true`
      // both seem to be required for this
      // to work without causing the UI widget
      // rendering this to throw an exception on build.
      ref.maintainState = true;
      return TextResponsesTransientMultiEditorManager();
    }
);