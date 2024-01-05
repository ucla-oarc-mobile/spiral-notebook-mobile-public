import 'package:spiral_notebook/models/shared_artifact/shared_artifact.dart';
import 'package:spiral_notebook/models/response/file_response_remote.dart';


const sharedArtifactJSONCacheParam = 'parentSharedArtifact';

class SharedArtifacts {
  List<SharedArtifact> artifacts;

  SharedArtifacts(this.artifacts);

  SharedArtifact getById(String id) => artifacts.firstWhere(
        (artifact) => artifact.id == id,
    orElse: () => throw Exception('invalid Artifact ID $id'),
  );

  static List<SharedArtifact> listFromArtifacts(List<dynamic> artifactsJson) {
    List<SharedArtifact> artifactsList = [];

    artifactsJson.forEach((artifactJson) {

      // the api may return the id in one of two methods:
      // either it returns a single Int of id, or it returns a hash
      // containing an id.

      final String portfolioId = (artifactJson['sharedPortfolio'].runtimeType == int)
          ? '${artifactJson['sharedPortfolio']}'
          : '${artifactJson['sharedPortfolio']['id']}';

      artifactsList.add(SharedArtifact.fromJson(
        parsedJson: artifactJson,
        portfolioId: portfolioId,
      ));
    });

    // ensure that all artifacts are sorted by date created. Critical!
    artifactsList
        .sort((a, b) => (a.dateCreated.compareTo(b.dateCreated)));
    return artifactsList;
  }

  SharedArtifacts withUpdatedSingleArtifactJson(Map<String, dynamic> artifactJson) {

    final String portfolioId = (artifactJson['sharedPortfolio'].runtimeType == int)
        ? '${artifactJson['sharedPortfolio']}'
        : '${artifactJson['sharedPortfolio']['id']}';
    final String artifactId = '${artifactJson['id']}';

    int indexToReplace = artifacts.indexWhere((artifact) => artifact.id == artifactId);
    SharedArtifact newArtifact = SharedArtifact.fromJson(parsedJson: artifactJson, portfolioId: portfolioId);

    (indexToReplace == -1)
        ? artifacts.add(newArtifact)
        : artifacts[indexToReplace] = newArtifact;

    return SharedArtifacts(this.artifacts);
  }

  SharedArtifacts withAddedArtifactFile(String artifactId, FileResponseRemote fileResponse) {

    int indexToReplace = artifacts.indexWhere((artifact) => artifact.id == artifactId);

    // the artifact ID doesn't exist yet in the collection - since we can't create one here,
    // just end right here and return the existing artifacts collection with no changes.
    if (indexToReplace == -1) return SharedArtifacts(this.artifacts);

    SharedArtifact newArtifact = SharedArtifact.fromAddedFile(oldSharedArtifact: artifacts[indexToReplace], fileResponse: fileResponse);
    artifacts[indexToReplace] = newArtifact;
    return SharedArtifacts(this.artifacts);
  }


  SharedArtifacts withRemovedArtifactFile(String artifactId, FileResponseRemote fileResponse) {

    int indexToReplace = artifacts.indexWhere((artifact) => artifact.id == artifactId);

    // the artifact ID doesn't exist yet in the collection - since we can't create one here,
    // just end right here and return the existing artifacts collection with no changes.
    if (indexToReplace == -1) return SharedArtifacts(this.artifacts);

    SharedArtifact newArtifact = SharedArtifact.fromRemovedFile(oldSharedArtifact: artifacts[indexToReplace], fileResponse: fileResponse);
    artifacts[indexToReplace] = newArtifact;
    return SharedArtifacts(this.artifacts);
  }

  SharedArtifacts withRemovedSharedArtifactId(String artifactId) {
    List<SharedArtifact> copySharedArtifacts = [...artifacts];

    int indexToRemove = artifacts.indexWhere((artifact) => artifact.id == artifactId);
    // the artifact ID doesn't exist in the collection - this is a problem.
    assert(indexToRemove != -1);

    copySharedArtifacts.removeAt(indexToRemove);

    return SharedArtifacts(copySharedArtifacts);
  }

  SharedArtifacts.fromJson(List<dynamic> parsedJson)
      : artifacts = listFromArtifacts(parsedJson);
}
