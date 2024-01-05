import 'package:spiral_notebook/models/questions/question.dart';
import 'package:spiral_notebook/models/questions/question_page.dart';
import 'package:spiral_notebook/models/questions/questions.dart';

class QuestionPages {
  List<QuestionPage> pages;

  QuestionPages(this.pages);

  bool pageContainsFilePrompt(int pageIndex) {
    bool result = false;

    // first, need to assert that the questionPages contains
    // the page we are trying to reference.
    assert(pages.indexWhere((qPage) => qPage.pageIndex == pageIndex) != -1);

    QuestionPage qPage = pages.firstWhere((qPage) => qPage.pageIndex == pageIndex);
    int fileIndex = qPage.questionList.indexWhere((question) => question.type == QuestionType.files);

    result = fileIndex != -1;
    return result;
  }

  static List<QuestionPage> assignPages(Questions questions) {
    List<QuestionPage> newPages = [];

    int i = 0;
    while (questions.questionsAtPage(i).isNotEmpty) {
      final QuestionPage questionPage = QuestionPage(
          questionList: questions.questionsAtPage(i),
          pageIndex: i,
      );
      newPages.add(questionPage);
      i++;
    }

    return newPages;
  }

  QuestionPages.fromQuestions(Questions questions)
    : pages = assignPages(questions);
}