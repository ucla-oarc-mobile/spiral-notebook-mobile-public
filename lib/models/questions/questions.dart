import 'package:spiral_notebook/api/api_constants.dart';
import 'package:spiral_notebook/models/portfolio/portfolio.dart';
import 'package:spiral_notebook/models/questions/question.dart';

class Questions {
  List<Question> questions;

  final List<dynamic> structure;

  // artifact id, used for submitting
  final String artifactId;

  Questions({
    required this.structure,
    required this.questions,
    required this.artifactId,
  });

  int get numPages => questions.map((e) => e.pageIndex).reduce((max, element) => (max > element) ? max : element) + 1;

  List<Question> questionsAtPage(int targetPageIndex) {
    List<Question> result = [];
    result = questions.where((question) => question.pageIndex == targetPageIndex).toList();
    return result;
  }

  Question? questionByKey(String promptKey) {
    Question? result;

    result = questions.cast<Question?>().firstWhere((element) => element?.promptKey == promptKey, orElse: () => null);
    return result;
  }

  static List<Question> assignQuestions(List<dynamic> structureListJson) {
    List<Question> newQuestions = [];
    // we are assuming that:
    // file Responses will always go on the first page.
    // Core questions always go on the second page.
    // all remaining pages will be automatically added to the following pages.
    int currentPageIndex = 2;
    int assignedIndex = 0;
    structureListJson.forEach((structureRowJson) {
      final bool isFilePrompt =
        apiPromptKeyTypeMap[structureRowJson[questionParamTypeKey]] == QuestionType.files;
      if (isFilePrompt) {
        // files prompt goes on the very first page.
        assignedIndex = 0;
      } else if (structureRowJson['core'] == true) {
        // this rule ensures that the first post-files page only contains core questions.
        assignedIndex = 1;
      } else {
        assignedIndex = currentPageIndex;
        currentPageIndex++;
      }

      // force blind type conversion of map key string,
      // in case we are loading questions from cached JSON.
      Map<String, dynamic> typeSafeJson = {};
      for (var type in structureRowJson.keys) {
        typeSafeJson[type.toString()] = structureRowJson[type];
      }

      newQuestions.add(
          Question.fromStructure(typeSafeJson, assignedIndex)
      );
    });
    return newQuestions;
  }

  Questions.fromPortfolio(Portfolio portfolio, String artifactId)
    : structure = portfolio.structure,
      artifactId = artifactId,
      questions = assignQuestions(portfolio.structure);

  Questions.fromUniversalArtifact(List<dynamic> structure, String artifactId)
      : structure = structure,
        artifactId = artifactId,
        questions = assignQuestions(structure);

}