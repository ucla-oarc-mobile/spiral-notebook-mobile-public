import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/api/api_constants.dart';
import 'package:spiral_notebook/models/questions/question.dart';
import 'package:spiral_notebook/models/response/text_response_base.dart';
import 'package:spiral_notebook/models/response/text_response_validators.dart';

class TextResponseTransientSingleEditor {
  TextResponseTransientSingleEditor() : super();

  bool synced = true;

  late Question question;

  late TextResponseBase _response;

  dynamic syncedValue;

  void updateValue(dynamic value) {
    // when a value has been modified, it is no longer synced.
    // since some updaters update the response state inline,
    // use a cached previousValue to determine if it's been modified.
    synced = (value == syncedValue);
    _response.valueDynamic = value;
  }

  dynamic getValue() => _response.valueDynamic;

  Map<String, dynamic> getEditPayload() {
    Map<String, dynamic> payload = {};

    Map<String, dynamic> responseJson = {};

    responseJson[_response.promptKey] = _response.valueDynamic;

    payload[artifactParamResponsesKey] = responseJson;

    return payload;
  }

  void markSynced() {
    synced = true;
    syncedValue = _response.valueDynamic;
  }

  void validate() {
    const maxErrorLabelLength = 20;
    String questionErrorLabel = (question.label.length > maxErrorLabelLength)
        ? question.label.substring(0, maxErrorLabelLength - 1) + "…"
        : question.label;
    assert(textResponseValidators.containsKey(_response.type));

    if (question.isRequired)
      textResponseValidators[_response.type]!.call(_response, questionErrorLabel);
  }

  TextResponseTransientSingleEditor.fromQuestion(Question question, dynamic value)
      : question = question,
        syncedValue = value,
        _response = TextResponseBase.fromValue(value: value, type: question.type, promptKey: question.promptKey);
}

class TextResponseTransientSingleEditorManager extends StateNotifier<TextResponseTransientSingleEditor> {
  TextResponseTransientSingleEditorManager() : super(TextResponseTransientSingleEditor());

  void initWithQuestion({required Question question, required dynamic value}) {
    state = TextResponseTransientSingleEditor.fromQuestion(question, value);
  }

  void reset() {
    state = TextResponseTransientSingleEditor();
  }
}

final textResponsesTransientSingleEditorProvider =
  StateNotifierProvider.autoDispose<TextResponseTransientSingleEditorManager, TextResponseTransientSingleEditor>(
        (ref) {
      //.autoDispose and `maintainState = true`
      // both seem to be required for this
      // to work without causing the UI widget
      // rendering this to throw an exception on build.
      ref.maintainState = true;
      return TextResponseTransientSingleEditorManager();
    }
);