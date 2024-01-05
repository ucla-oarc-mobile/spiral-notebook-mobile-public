import 'package:spiral_notebook/models/response/file_response_base.dart';
import 'package:spiral_notebook/models/response/file_response_remote.dart';

class FileResponsesRemote {
  FileResponsesRemote(this.responses);

  List<FileResponseRemote> responses = [];

  static List<FileResponseRemote> addRemotesFromArtifact(Map<String, dynamic> responsesJson) {
    List<FileResponseRemote> result = [];
    List<dynamic> documentsJson = responsesJson['documents'] ?? [];
    List<dynamic> imagesJson = responsesJson['images'] ?? [];
    List<dynamic> videosJson = responsesJson['videos'] ?? [];

    if (documentsJson.isNotEmpty)
      documentsJson.forEach((documentJson) =>
          result.add(
              FileResponseRemote.fromResponse(
                responseJson: documentJson,
                type: ArtifactFileResponseType.document,
              )));
    if (imagesJson.isNotEmpty)
      imagesJson.forEach((imageJson) =>
          result.add(
              FileResponseRemote.fromResponse(
                responseJson: imageJson,
                type: ArtifactFileResponseType.image,
              )));
    if (videosJson.isNotEmpty)
      videosJson.forEach((videoJson) =>
          result.add(
              FileResponseRemote.fromResponse(
                responseJson: videoJson,
                type: ArtifactFileResponseType.video,
              )));

    return result;
  }
  void addResponse(FileResponseRemote fileResponse) {

    int indexToAdd = responses.indexWhere((response) => response.remoteId == fileResponse.remoteId);
    if (indexToAdd == -1) {
      // only add the file if it's not already present.
      responses.add(fileResponse);
    }
  }

  FileResponsesRemote copyWithAddedFile(FileResponseRemote fileResponse) {
    addResponse(fileResponse);
    return FileResponsesRemote([...responses]);
  }

  FileResponsesRemote copyWithRemovedFile(FileResponseRemote fileResponse) {

    List<FileResponseRemote> copyResponses = [...responses];

    int indexToRemove = copyResponses.indexWhere((response) => response.remoteId == fileResponse.remoteId);
    assert(indexToRemove != -1);

    copyResponses.removeAt(indexToRemove);

    return FileResponsesRemote(copyResponses);
  }

  List<FileResponseRemote> getResponsesByType(ArtifactFileResponseType type) {
    List<FileResponseRemote> result = [];

    result = responses.where((response) => response.type == type).toList();
    return result;
  }

  void deleteById(String remoteId) {
    responses.removeWhere((response) => response.remoteId == remoteId);
  }

  FileResponsesRemote.fromArtifactJson(Map<String, dynamic> artifactJson)
      : responses = addRemotesFromArtifact(artifactJson);
}