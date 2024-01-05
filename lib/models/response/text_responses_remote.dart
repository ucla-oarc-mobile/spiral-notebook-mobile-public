import 'package:spiral_notebook/api/api_constants.dart';
import 'package:spiral_notebook/models/questions/question.dart';
import 'package:spiral_notebook/models/response/text_response_base.dart';
import 'package:spiral_notebook/models/response/text_responses.dart';

class TextResponsesRemote extends TextResponses {
  static QuestionType _getQuestionTypeFromKey(List<dynamic> structureJson, String promptKey) {
    Map<String, dynamic> result = {};

    // duplicates code from Portfolio.getStructureRowJson,
    // but no easy way to include this without weird dependencies.
    result = structureJson.firstWhere(
          (element) => element['key'] == promptKey,
    );
    final String remoteType = result['type'];

    // this is duplicating code from Question type, but don't
    // know how to use it without weird dependencies.
    assert(apiPromptKeyTypeMap.containsKey(remoteType));
    return apiPromptKeyTypeMap[remoteType]!;
  }

  static Map<String, TextResponseBase> assignRemoteTextResponses(Map<String, dynamic> parsedJson) {
    Map<String, TextResponseBase> result = {};
    Map<String, dynamic>? remoteResponses = parsedJson[artifactParamResponsesKey];

    // no responses - leave it empty!
    if (remoteResponses == null || remoteResponses.isEmpty) return result;

    final List<dynamic> structureJson = parsedJson[artifactParamQuestionStructureKey];
    if (structureJson.isEmpty) return result;

    remoteResponses.forEach((promptKey, value) {

      if (structureJson.map((row) => row['key']).toList().contains(promptKey)) {
        // only create a response if there is a matching prompt key in the structure.
        result[promptKey] = TextResponseBase.fromValue(
          value: value,
          type: _getQuestionTypeFromKey(structureJson, promptKey),
          promptKey: promptKey,
        );
      }
    });

    return result;
  }

  TextResponsesRemote.fromRemoteJson(Map<String, dynamic> parsedJson)
      : super(assignRemoteTextResponses(parsedJson));
}