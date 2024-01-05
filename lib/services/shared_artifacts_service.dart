import 'package:spiral_notebook/api/eqis_api.dart';


class SharedArtifactsService {
  final _artifact = EqisAPI();

  Future<dynamic> fetchSharedArtifacts() async {
    final artifacts = await _artifact.fetchSharedArtifacts();

    return artifacts;
  }

  Future<dynamic> deleteSharedArtifact({required String artifactId}) async {
    final deleteArtifactResult = await _artifact.deleteSharedArtifact(artifactId: artifactId);
    return deleteArtifactResult;
  }
}