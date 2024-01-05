import 'package:spiral_notebook/models/response/text_response_base.dart';

abstract class TextResponses {
  TextResponses(this.responses);
  // responses are stored as a Map, where the index
  // is the promptKey of the response.
  Map<String, TextResponseBase> responses = {};

  void updateValueByKey(String promptKey, dynamic value) {
    // update a specific response in the collection by its key.
    assert(responses.containsKey(promptKey));

    responses[promptKey]!.valueDynamic = value;
  }

  dynamic getValueByKey(String promptKey) {
    // get a specific response in the collection by its key.
    return (responses.containsKey(promptKey))
      ? responses[promptKey]!.valueDynamic
     : null;
  }

  void clear() {
    // clear all responses.
    responses = {};
  }

}