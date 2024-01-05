import 'package:spiral_notebook/models/artifact/artifact.dart';
import 'package:spiral_notebook/models/response/file_response_remote.dart';

const artifactJSONCacheParam = 'parentArtifact';

class Artifacts {
  List<Artifact> artifacts;

  Artifacts(this.artifacts);

  Artifact getById(String id) => artifacts.firstWhere(
        (artifact) => artifact.id == id,
    orElse: () => throw Exception('invalid Artifact ID $id'),
  );

  static List<Artifact> listFromArtifacts(List<dynamic> artifactsJson) {
    List<Artifact> artifactsList = [];

    artifactsJson.forEach((artifactJson) {

      // the api may return the id in one of two methods:
      // either it returns a single Int of id, or it returns a hash
      // containing an id.

      final String portfolioId = (artifactJson['portfolio'].runtimeType == int)
          ? '${artifactJson['portfolio']}'
          : '${artifactJson['portfolio']['id']}';

      artifactsList.add(Artifact.fromJson(
          parsedJson: artifactJson,
          portfolioId: portfolioId,
      ));
    });

    // ensure that all artifacts are sorted by date created. Critical!
    artifactsList
        .sort((a, b) => (a.dateCreated.compareTo(b.dateCreated)));
    return artifactsList;
  }

  Artifacts withUpdatedSingleArtifactJson(Map<String, dynamic> artifactJson) {

    final String portfolioId = (artifactJson['portfolio'].runtimeType == int)
        ? '${artifactJson['portfolio']}'
        : '${artifactJson['portfolio']['id']}';
    final String artifactId = '${artifactJson['id']}';

    int indexToReplace = artifacts.indexWhere((artifact) => artifact.id == artifactId);
    Artifact newArtifact = Artifact.fromJson(parsedJson: artifactJson, portfolioId: portfolioId);

    (indexToReplace == -1)
      ? artifacts.add(newArtifact)
      : artifacts[indexToReplace] = newArtifact;

    return Artifacts(this.artifacts);
  }

  Artifacts withAddedArtifactFile(String artifactId, FileResponseRemote fileResponse) {

    int indexToReplace = artifacts.indexWhere((artifact) => artifact.id == artifactId);

    // the artifact ID doesn't exist yet in the collection - since we can't create one here,
    // just end right here and return the existing artifacts collection with no changes.
    if (indexToReplace == -1) return Artifacts(this.artifacts);

    Artifact newArtifact = Artifact.fromAddedFile(oldArtifact: artifacts[indexToReplace], fileResponse: fileResponse);
    artifacts[indexToReplace] = newArtifact;
    return Artifacts(this.artifacts);
  }


  Artifacts withRemovedArtifactFile(String artifactId, FileResponseRemote fileResponse) {

    int indexToReplace = artifacts.indexWhere((artifact) => artifact.id == artifactId);

    // the artifact ID doesn't exist yet in the collection - since we can't create one here,
    // just end right here and return the existing artifacts collection with no changes.
    if (indexToReplace == -1) return Artifacts(this.artifacts);

    Artifact newArtifact = Artifact.fromRemovedFile(oldArtifact: artifacts[indexToReplace], fileResponse: fileResponse);
    artifacts[indexToReplace] = newArtifact;
    return Artifacts(this.artifacts);
  }

  Artifacts withRemovedArtifactId(String artifactId) {
    List<Artifact> copyArtifacts = [...artifacts];

    int indexToRemove = artifacts.indexWhere((artifact) => artifact.id == artifactId);
    // the artifact ID doesn't exist in the collection - this is a problem.
    assert(indexToRemove != -1);

    copyArtifacts.removeAt(indexToRemove);

    return Artifacts(copyArtifacts);
  }

  Artifacts.fromJson(List<dynamic> parsedJson)
      : artifacts = listFromArtifacts(parsedJson);
}
