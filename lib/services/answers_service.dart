import 'package:spiral_notebook/api/eqis_api.dart';


class AnswersService {
  final _answers = EqisAPI();

  Future<dynamic> getNewArtifactId({required String portfolioId}) async {
    final Map<String, dynamic> jsonResponse = await _answers.getNewArtifactId(portfolioId: portfolioId);

    String artifactId =  "${jsonResponse['id']}";

    print(artifactId);

    return artifactId;
  }

  Future<dynamic> submitArtifactTextResponses({
    required Map <String, dynamic> body,
    required String portfolioId,
    required String artifactId,
  }) async {
    final dynamic submitResult = await _answers.submitArtifactTextResponses(
        requestBody: body,
        portfolioId: portfolioId,
        artifactId: artifactId,
    );

    return submitResult;
  }

  Future<dynamic> submitSharedArtifactTextResponses({
    required Map <String, dynamic> body,
    required String sharedPortfolioId,
    required String sharedArtifactId,
  }) async {
    final dynamic submitResult = await _answers.submitSharedArtifactTextResponses(
        requestBody: body,
        sharedPortfolioId: sharedPortfolioId,
        sharedArtifactId: sharedArtifactId,
    );

    return submitResult;
  }

  Future<dynamic> gateCheckSharedArtifactEdit({
    required String sharedPortfolioId,
    required String sharedArtifactId,
    required DateTime dateModified,
  }) async {
    final dynamic submitResult = await _answers.gateCheckSharedArtifactEdit(
      sharedPortfolioId: sharedPortfolioId,
      sharedArtifactId: sharedArtifactId,
      dateModified: dateModified,
    );

    return submitResult;
  }


}