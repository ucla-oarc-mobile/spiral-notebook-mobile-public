
import 'package:hive/hive.dart';

part 'shared_artifacts_reaction.g.dart';

@HiveType(typeId: 10)
class SharedArtifactsReaction {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String value;
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

  SharedArtifactsReaction({
    required this.id,
    required this.value,
    required this.dateCreated,
    required this.dateModified,
    required this.ownerId,
    required this.ownerEmail,
    required this.ownerUsername,
    required this.sharedArtifactId,
    required this.sharedPortfolioId,
  });

  // Current user details come from a Provider, can't access user id
  // inside of a non-widget class method.
  // Because of caching, don't want to nest CurrentUser object
  // inside of this either - that can cause problems.
  // For these reasons, we determine this only at runtime.
  bool ownedByCurrentUserId(String currentId) => (currentId == ownerId);

  SharedArtifactsReaction.fromJson({required Map<String, dynamic> parsedJson})
      : id = "${parsedJson['id']}",
        value = "${parsedJson['value']}",
        dateCreated = DateTime.parse(parsedJson['created_at']),
        dateModified = DateTime.parse(parsedJson['updated_at']),
        ownerId = "${parsedJson['owner']['id']}",
        ownerEmail = "${parsedJson['owner']['email']}",
        ownerUsername = "${parsedJson['owner']['username']}",
        sharedArtifactId = "${parsedJson['sharedArtifact']['id']}",
        sharedPortfolioId = "${parsedJson['sharedArtifact']['sharedPortfolio']}";
}