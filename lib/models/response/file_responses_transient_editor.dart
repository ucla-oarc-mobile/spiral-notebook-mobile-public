
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/api/response_object_with_parent_cache.dart';
import 'package:spiral_notebook/models/artifact/artifact.dart';
import 'package:spiral_notebook/models/artifact/artifacts.dart';
import 'package:spiral_notebook/models/response/file_response_base.dart';
import 'package:spiral_notebook/models/response/file_response_local.dart';
import 'package:spiral_notebook/models/response/file_response_remote.dart';
import 'package:spiral_notebook/models/response/file_responses_local.dart';
import 'package:spiral_notebook/models/response/file_responses_remote.dart';
import 'package:spiral_notebook/models/shared_artifact/shared_artifact.dart';
import 'package:spiral_notebook/models/shared_artifact/shared_artifacts.dart';
import 'package:spiral_notebook/services/file_upload_service.dart';

class FileResponsesTransientEditor {
  FileResponsesTransientEditor();

  FileResponsesLocal responsesLocal = FileResponsesLocal();
  FileResponsesRemote responsesRemote = FileResponsesRemote([]);
  List<dynamic> get responseDocumentsAll => [
    ...responsesRemote.getResponsesByType(ArtifactFileResponseType.document),
    ...responsesLocal.getResponsesByType(ArtifactFileResponseType.document),
  ];
  List<dynamic> get responseImagesAll => [
    ...responsesRemote.getResponsesByType(ArtifactFileResponseType.image),
    ...responsesLocal.getResponsesByType(ArtifactFileResponseType.image),
  ];
  List<dynamic> get responseVideosAll => [
    ...responsesRemote.getResponsesByType(ArtifactFileResponseType.video),
    ...responsesLocal.getResponsesByType(ArtifactFileResponseType.video),
  ];


  int get responsesLocalCount => responsesLocal.responses.length;

  int get responsesAllCount => [
    ...responsesLocal.responses,
    ...responsesRemote.responses
  ].length;

  bool get areResponsesEmpty => (
      [
        ...responsesLocal.responses,
        ...responsesRemote.responses
      ].length == 0
  );

  void validateFileResponses() {
    if (areResponsesEmpty)
      throw FormatException('Please add a file to this artifact.');
  }

  String? universalArtifactId;
  String? portfolioId;
  bool isSharedArtifact = false;

  Future<ResponseObjectWithParentCache> replaceFirstLocalWithRemote() async {
    final FileUploadService _fileUpload = FileUploadService();

    assert(responsesLocal.responses.length > 0);

    FileResponseLocal responseLocal = responsesLocal.responses[0];
    Map<String, dynamic> responseJson = await _fileUpload.uploadFileByType(
      artifactId: universalArtifactId!,
      portfolioId: portfolioId!,
      myFile: responseLocal.value,
      fileType: responseLocal.type,
      isSharedArtifact: isSharedArtifact,
    );
    // create a new Remote file from this file!
    final FileResponseRemote newRemote = FileResponseRemote.fromResponse(
      responseJson: responseJson,
      type: responseLocal.type,
    );
    // remove the local version of this file
    responsesLocal.removeByPath(responseLocal.localPath);
    responsesRemote.addResponse(newRemote);

    return ResponseObjectWithParentCache.fromJson(
        responseObj: newRemote,
        rawJSON: responseJson,
        cacheParam: isSharedArtifact ? sharedArtifactJSONCacheParam : artifactJSONCacheParam,
    );
  }

  Future<ResponseObjectWithParentCache> _deleteRemoteFileById(String fileId, ArtifactFileResponseType fileType) async {
    // File choosers call this when removing a Remote file from the list.
    final FileUploadService _fileUpload = FileUploadService();
    dynamic result = await _fileUpload.deleteFile(
        portfolioId: portfolioId!,
        artifactId: universalArtifactId!,
        fileId: fileId,
        fileType: fileType,
        isSharedArtifact: isSharedArtifact,
    );

    return ResponseObjectWithParentCache.fromJson(
      responseObj: {}, // no object to return, will be using only the cache JSON
      rawJSON: result,
      cacheParam: isSharedArtifact ? sharedArtifactJSONCacheParam : artifactJSONCacheParam,
    );
  }

  Future<ResponseObjectWithParentCache> deleteRemote(FileResponseRemote remoteResponse) async {
    ResponseObjectWithParentCache result = await _deleteRemoteFileById(remoteResponse.remoteId, remoteResponse.type);
    responsesRemote.deleteById(remoteResponse.remoteId);
    return result;
  }

  void deleteLocal(FileResponseLocal localResponse) =>
      responsesLocal.removeByPath(localResponse.localPath);

  FileResponsesTransientEditor.fromIds({required String artifactId, required String portfolioId})
      : universalArtifactId = artifactId,
        portfolioId = portfolioId;

  // the api may return the id in one of two methods:
  // either it returns a single Int of id, or it returns a hash
  // containing an id.
  static String portfolioIdFromJson(Map<String, dynamic> artifactJson) => (artifactJson['portfolio'].runtimeType == int)
      ? '${artifactJson['portfolio']}'
      : '${artifactJson['portfolio']['id']}';

  // TODO: Caching - add constructor .fromCache to load file responses from cache

  FileResponsesTransientEditor.fromArtifact(Artifact artifact)
      // be careful with referencing values - they were updating the artifact
      // properties directly! This syntax
      // `responsesRemote = artifact.fileResponses`
      // results in file operations being performed directly on the Artifact
      // with unexpected consequences.
      : universalArtifactId = '${artifact.id}',
        isSharedArtifact = false,
        portfolioId = '${artifact.portfolioId}',
        responsesRemote = FileResponsesRemote([...artifact.fileResponses.responses]);

  FileResponsesTransientEditor.fromSharedArtifact(SharedArtifact sharedArtifact)
  // be careful with referencing values - they were updating the artifact
  // properties directly! This syntax
  // `responsesRemote = artifact.fileResponses`
  // results in file operations being performed directly on the Artifact
  // with unexpected consequences.
      : universalArtifactId = '${sharedArtifact.id}',
        isSharedArtifact = true,
        portfolioId = '${sharedArtifact.sharedPortfolioId}',
        responsesRemote = FileResponsesRemote([...sharedArtifact.fileResponses.responses]);
}


class FileResponsesTransientEditorManager extends StateNotifier<FileResponsesTransientEditor> {

  FileResponsesTransientEditorManager() : super(FileResponsesTransientEditor());


  void initBlankWithIds({required String artifactId, required String portfolioId}) {
    state = FileResponsesTransientEditor.fromIds(artifactId: artifactId, portfolioId: portfolioId);
  }

  void initWithArtifact(Artifact artifact) {
    state = FileResponsesTransientEditor.fromArtifact(artifact);
  }

  void initWithSharedArtifact(SharedArtifact artifact) {
    state = FileResponsesTransientEditor.fromSharedArtifact(artifact);
  }
  // TODO: Caching - add state initializer .fromCache to load file responses from cache

}

final fileResponsesTransientEditorProvider = StateNotifierProvider.autoDispose<FileResponsesTransientEditorManager, FileResponsesTransientEditor>(
        (ref) {
      //.autoDispose and `maintainState = true`
      // both seem to be required for this
      // to work without causing the UI widget
      // rendering this to throw an exception on build.
      ref.maintainState = true;
      return FileResponsesTransientEditorManager();
    }
);