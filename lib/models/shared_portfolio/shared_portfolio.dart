
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:spiral_notebook/api/api_constants.dart';

part 'shared_portfolio.g.dart';

@HiveType(typeId: 4)
class SharedPortfolio {

  @HiveField(0)
  final String id;
  // we store artifact IDs so they can be referenced in another Provider.
  @HiveField(1)
  final List<String> artifactIds;
  @HiveField(2)
  final DateTime dateCreated;
  @HiveField(3)
  final DateTime dateModified;
  @HiveField(4)
  final List<String> grades;
  @HiveField(5)
  final String name;
  @HiveField(6)
  final List<dynamic> structure;
  @HiveField(7)
  final String subject;
  @HiveField(8)
  final String topic;
  @HiveField(9)
  final String plcName;
  @HiveField(10)
  final String plcGoals;
  @HiveField(11)
  final int commentCount;
  @HiveField(12)
  final String ownerId;
  @HiveField(13)
  final String ownerName;

  SharedPortfolio({
    required this.id,
    required this.artifactIds,
    required this.commentCount,
    required this.dateCreated,
    required this.dateModified,
    required this.grades,
    required this.name,
    required this.ownerId,
    required this.ownerName,
    required this.plcGoals,
    required this.plcName,
    required this.structure,
    required this.subject,
    required this.topic,
  });

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

  void mergeNewArtifactId(String artifactId) {
    bool idDoesNotExist = (artifactIds.indexWhere((localId) => localId == artifactId) == -1);

    if (idDoesNotExist) artifactIds.add(artifactId);
  }

  static List<String> artifactIdsFromRemovedId({
    required List<String> oldIds,
    required String artifactId,
  }) {
    List<String> copyArtifactIds = [...oldIds];

    int indexToRemove = copyArtifactIds.indexWhere((id) => id == artifactId);
    // the artifact ID doesn't exist in the collection - this is a problem.
    assert(indexToRemove != -1);

    copyArtifactIds.removeAt(indexToRemove);

    return copyArtifactIds;
  }

  static List<String> listFromPortfolioArtifacts(List<dynamic> artifacts) {
    List<String> artifactsList = [];

    // TODO: Can optimize here. Server could send list of IDs instead of full sharedArtifacts obj
    artifacts.forEach((artifact) {
      artifactsList.add('${artifact['id']}');
    });

    return artifactsList;
  }

  static List<String> listFromGrades(List<dynamic> grades) {
    List<String> gradesList = [];

    grades.forEach((grade) {
      gradesList.add('$grade');
    });

    return gradesList;
  }

  SharedPortfolio.fromRemovedArtifactId({required SharedPortfolio oldPortfolio, required String artifactId})
      : id = oldPortfolio.id,
        artifactIds = artifactIdsFromRemovedId(oldIds: oldPortfolio.artifactIds, artifactId: artifactId),
        commentCount = oldPortfolio.commentCount,
        dateCreated = oldPortfolio.dateCreated,
        dateModified = DateTime.now(),
        grades = oldPortfolio.grades,
        name = oldPortfolio.name,
        ownerId = oldPortfolio.ownerId,
        ownerName = oldPortfolio.ownerName,
        plcName = oldPortfolio.plcName,
        plcGoals = oldPortfolio.plcGoals,
        structure = oldPortfolio.structure,
        subject = oldPortfolio.subject,
        topic = oldPortfolio.topic;

  SharedPortfolio.fromJson({required Map<String, dynamic> parsedJson})
      : id = "${parsedJson['id']}",
        artifactIds = listFromPortfolioArtifacts(parsedJson['sharedArtifacts']),
        commentCount = int.parse("${parsedJson['commentCount']}"),
        dateCreated = DateTime.parse(parsedJson['created_at']),
        dateModified = DateTime.parse(parsedJson['updated_at']),
        grades = listFromGrades(parsedJson['grades']),
        name = "${parsedJson['name']}",
        ownerId = "${parsedJson['owner']['id']}",
        ownerName = "${parsedJson['owner']['name']}",
        plcName = "${parsedJson['plcName']}",
        plcGoals = "${parsedJson['plcGoals']}",
        structure = parsedJson[artifactParamQuestionStructureKey],
        subject = "${parsedJson['subject']}",
        topic = "${parsedJson['topic']}";

}