
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'shared_artifacts_comment.g.dart';

@HiveType(typeId: 8)
class SharedArtifactsComment {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String body;
  @HiveField(2)
  final DateTime dateCreated;
  @HiveField(3)
  final DateTime dateModified;
  @HiveField(4)
  final String ownerId;
  @HiveField(5)
  final String ownerEmail;
  @HiveField(6)
  final String ownerUsername;
  @HiveField(7)
  final String sharedArtifactId;
  @HiveField(8)
  final String sharedPortfolioId;

  SharedArtifactsComment({
    required this.id,
    required this.body,
    required this.dateCreated,
    required this.dateModified,
    required this.ownerId,
    required this.ownerEmail,
    required this.ownerUsername,
    required this.sharedArtifactId,
    required this.sharedPortfolioId,
  });

  String get displayName {
    return ownerUsername;
  }

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

  // Current user details come from a Provider, can't access user id
  // inside of a non-widget class method.
  // Because of caching, don't want to nest CurrentUser object
  // inside of this either - that can cause problems.
  // For these reasons, we determine this only at runtime.
  bool ownedByCurrentUserId(String currentId) => (currentId == ownerId);

  SharedArtifactsComment.fromJson({required Map<String, dynamic> parsedJson})
      : id = "${parsedJson['id']}",
        body = "${parsedJson['text']}",
        dateCreated = DateTime.parse(parsedJson['created_at']),
        dateModified = DateTime.parse(parsedJson['updated_at']),
        ownerId = "${parsedJson['owner']['id']}",
        ownerEmail = "${parsedJson['owner']['email']}",
        ownerUsername = "${parsedJson['owner']['username']}",
        sharedArtifactId = "${parsedJson['sharedArtifact']['id']}",
        sharedPortfolioId = "${parsedJson['sharedArtifact']['sharedPortfolio']}";
}