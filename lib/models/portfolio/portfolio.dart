
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:spiral_notebook/api/api_constants.dart';

part 'portfolio.g.dart';

@HiveType(typeId: 0)
class Portfolio {

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

  Portfolio({
    required this.id,
    required this.artifactIds,
    required this.dateCreated,
    required this.dateModified,
    required this.grades,
    required this.name,
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
    String date = formatter.format(dateCreated.toLocal());
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

  Portfolio.fromJson({required Map<String, dynamic> parsedJson})
      : id = "${parsedJson['id']}",
  artifactIds = listFromPortfolioArtifacts(parsedJson['artifacts']),
        dateCreated = DateTime.parse(parsedJson['created_at']),
        dateModified = DateTime.parse(parsedJson['updated_at']),
        grades = listFromGrades(parsedJson['grades']),
        name = "${parsedJson['name']}",
        structure = parsedJson[artifactParamQuestionStructureKey],
        subject = "${parsedJson['subject']}",
        topic = "${parsedJson['topic']}";

  Portfolio.fromRemovedArtifactId({required Portfolio oldPortfolio, required String artifactId})
      : id = oldPortfolio.id,
        artifactIds = artifactIdsFromRemovedId(oldIds: oldPortfolio.artifactIds, artifactId: artifactId),
        dateCreated = oldPortfolio.dateCreated,
        dateModified = DateTime.now(),
        grades = oldPortfolio.grades,
        name = oldPortfolio.name,
        structure = oldPortfolio.structure,
        subject = oldPortfolio.subject,
        topic = oldPortfolio.topic;
}