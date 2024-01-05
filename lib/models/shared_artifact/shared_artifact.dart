import 'package:intl/intl.dart';
import 'package:spiral_notebook/api/api_constants.dart';
import 'package:spiral_notebook/models/response/file_response_base.dart';
import 'package:spiral_notebook/models/response/file_response_remote.dart';
import 'package:spiral_notebook/models/response/file_responses_remote.dart';
import 'package:spiral_notebook/models/response/text_responses_remote.dart';
import 'package:spiral_notebook/providers/artifact_operations_provider.dart';


class SharedArtifact {
  final String id;
  final DateTime dateCreated;
  final DateTime dateModified;
  final String sharedPortfolioId;
  final List<dynamic> structure;

  final String ownerId;
  final String ownerEmail;
  final String ownerUsername;

  // responses are stored as a Map, where the index
  // is the promptKey of the responses.
  TextResponsesRemote textResponsesRemote;

  FileResponsesRemote fileResponses;

  // TODO: Add storing comments

  String get displayName {
    return ownerUsername;
  }
  String get formattedDateCreated {
    var formatter = new DateFormat('MM-dd-yy');
    String date = formatter.format(dateCreated.toLocal());
    return date;
  }

  String get formattedDateModified {
    var formatter = new DateFormat('MM-dd-yy');
    String date = formatter.format(dateModified.toLocal());
    return date;
  }

  String get name => textResponsesRemote.getValueByKey('artifactName') ?? '(Unnamed)';

  String get unitTiming =>
      textResponsesRemote.getValueByKey('unitTiming') ?? '(None Specified)';

  String get categoryString {
    List<String> choices = textResponsesRemote.getValueByKey('artifactCategory') ?? ['(None Specified)'];
    return choices.reduce((value, element) => value + ", " + element);
  }

  String get unitDay {
    final int? myDay = textResponsesRemote.getValueByKey('unitDay');
    return (myDay == null)
        ? '(None Specified)' : '$myDay';
  }

  Map<String, dynamic> getStructureRowJson(String promptKey) {
    Map<String, dynamic> result = {};
    assert(structure.map((row) => row['key']).toList().contains(promptKey));
    result = structure.firstWhere(
          (element) => element['key'] == promptKey,
    );
    return result;
  }

  dynamic getTextValueByKey(String promptKey) =>
      textResponsesRemote.getValueByKey(promptKey);

  ModifyArtifactFileType get modifyFileType {
    final bool containsDocuments =
        fileResponses.getResponsesByType(ArtifactFileResponseType.document).length > 0;
    return containsDocuments
        ? ModifyArtifactFileType.document
        : ModifyArtifactFileType.media;
  }


  SharedArtifact.fromJson({required Map<String, dynamic> parsedJson, required String portfolioId})
      : id = "${parsedJson['id']}",
        dateCreated = DateTime.parse(parsedJson['created_at']),
        dateModified = DateTime.parse(parsedJson['updated_at']),
        ownerId = "${parsedJson['owner']['id']}",
        ownerEmail = "${parsedJson['owner']['email']}",
        ownerUsername = "${parsedJson['owner']['username']}",
        structure = parsedJson[artifactParamQuestionStructureKey],
        sharedPortfolioId = portfolioId,
        textResponsesRemote = TextResponsesRemote.fromRemoteJson(parsedJson),
        fileResponses = FileResponsesRemote.fromArtifactJson(parsedJson);

  // constructor to generate a new artifact, based on an old one,
  // with an added FileResponseRemote.
  SharedArtifact.fromAddedFile({required SharedArtifact oldSharedArtifact, required FileResponseRemote fileResponse})
      : id = oldSharedArtifact.id,
        dateCreated = oldSharedArtifact.dateCreated,
        dateModified = DateTime.now(),
        ownerId = oldSharedArtifact.ownerId,
        ownerEmail = oldSharedArtifact.ownerEmail,
        ownerUsername = oldSharedArtifact.ownerUsername,
        sharedPortfolioId = oldSharedArtifact.sharedPortfolioId,
        structure = oldSharedArtifact.structure,
        textResponsesRemote = oldSharedArtifact.textResponsesRemote,
        fileResponses = oldSharedArtifact.fileResponses.copyWithAddedFile(fileResponse);

  SharedArtifact.fromRemovedFile({required SharedArtifact oldSharedArtifact, required FileResponseRemote fileResponse})
      : id = oldSharedArtifact.id,
        dateCreated = oldSharedArtifact.dateCreated,
        dateModified = DateTime.now(),
        ownerId = oldSharedArtifact.ownerId,
        ownerEmail = oldSharedArtifact.ownerEmail,
        ownerUsername = oldSharedArtifact.ownerUsername,
        sharedPortfolioId = oldSharedArtifact.sharedPortfolioId,
        structure = oldSharedArtifact.structure,
        textResponsesRemote = oldSharedArtifact.textResponsesRemote,
        fileResponses = oldSharedArtifact.fileResponses.copyWithRemovedFile(fileResponse);

}