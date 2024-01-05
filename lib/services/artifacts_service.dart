import 'package:spiral_notebook/api/eqis_api.dart';


class ArtifactsService {
  final _artifact = EqisAPI();

  Future<dynamic> fetchArtifacts() async {
    final artifacts = await _artifact.fetchArtifacts();

    return artifacts;
  }

  Future<dynamic> copyArtifactToSharedPortfolio({
    required String artifactId,
    required String sharedPortfolioId,
  }) async {
    final sharedArtifactResult = await _artifact.copyArtifactToSharedPortfolio(
        artifactId: artifactId,
        sharedPortfolioId: sharedPortfolioId,
    );

    return sharedArtifactResult;
  }

  Future<dynamic> copySharedArtifactToSharedPortfolio({
    required String sharedArtifactId,
    required String sharedPortfolioId,
  }) async {
    final sharedArtifactResult = await _artifact.copySharedArtifactToSharedPortfolio(
      sharedArtifactId: sharedArtifactId,
      sharedPortfolioId: sharedPortfolioId,
    );

    return sharedArtifactResult;
  }

  Future<dynamic> deleteArtifact({required String artifactId}) async {
    final deleteArtifactResult = await _artifact.deleteArtifact(artifactId: artifactId);
    return deleteArtifactResult;
  }
}