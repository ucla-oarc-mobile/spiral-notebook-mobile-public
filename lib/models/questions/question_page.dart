import 'package:spiral_notebook/models/questions/question.dart';

class QuestionPage {
  List<Question> questionList;

  int pageIndex;

  QuestionPage({
    required this.questionList,
    required this.pageIndex,
  });

}