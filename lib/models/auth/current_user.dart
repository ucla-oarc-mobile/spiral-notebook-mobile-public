import 'package:spiral_notebook/models/auth/auth_user.dart';
import 'package:hive/hive.dart';

part 'current_user.g.dart';

@HiveType(typeId: 3)
class CurrentAuthUser {
  @HiveField(0)
  AuthUser? myUser;

  CurrentAuthUser({this.myUser});

  CurrentAuthUser.fromJson(Map<String, dynamic> parsedJson)
      : myUser = AuthUser.fromJson(parsedJson: parsedJson);
}