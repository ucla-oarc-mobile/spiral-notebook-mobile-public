import 'package:spiral_notebook/models/questions/question.dart';

const Map<String, QuestionType> apiPromptKeyTypeMap = {
  'fileUpload': QuestionType.files,
  'number': QuestionType.number,
  'shortText': QuestionType.shortText,
  'longText': QuestionType.longText,
  'singleSelection': QuestionType.singleChoice,
  'multipleResponse': QuestionType.multiChoice,
  'expansionPanelChoices': QuestionType.expansionPanelChoices,
};

const artifactParamParkingLotFlag = 'parkingLot';

const artifactParamUniqueId = 'id';

const artifactParamQuestionStructureKey = 'structure';

const artifactParamResponsesKey = 'responses';

const questionParamTypeKey = 'type';