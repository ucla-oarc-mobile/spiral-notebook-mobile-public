import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'auth_user.g.dart';

@HiveType(typeId: 2)
class AuthUser {
  // All fields are optional, because before they first log in,
  // this entity should be completely empty.

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final bool isConfirmed;
  @HiveField(4)
  final bool isBlocked;
  @HiveField(5)
  final String roleId;
  @HiveField(6)
  final String roleName;
  @HiveField(7)
  final String roleDescription;
  @HiveField(8)
  final DateTime dateCreated;
  @HiveField(9)
  final DateTime dateModified;

  AuthUser({
    required this.id,
    required this.username,
    required this.email,
    required this.isConfirmed,
    required this.isBlocked,
    required this.roleId,
    required this.roleName,
    required this.roleDescription,
    required this.dateCreated,
    required this.dateModified,
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

  AuthUser.fromJson({required Map<String, dynamic> parsedJson})
  : id = "${parsedJson['id']}",
        username = "${parsedJson['username']}",
        email = "${parsedJson['email']}",
        isConfirmed = parsedJson['confirmed'],
        isBlocked = parsedJson['blocked'],
        roleId = '${parsedJson['role']['id']}',
        roleName = '${parsedJson['role']['name']}',
        roleDescription = '${parsedJson['role']['description']}',
        dateCreated = DateTime.parse(parsedJson['created_at']),
        dateModified = DateTime.parse(parsedJson['updated_at']);
}