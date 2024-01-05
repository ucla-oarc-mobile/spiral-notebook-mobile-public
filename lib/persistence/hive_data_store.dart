import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:spiral_notebook/models/auth/auth_user.dart';
import 'package:spiral_notebook/models/auth/current_user.dart';
import 'package:spiral_notebook/models/notifications_list/notifications_list.dart';
import 'package:spiral_notebook/models/notifications_list/notifications_list_item.dart';
import 'package:spiral_notebook/models/portfolio/my_portfolios.dart';
import 'package:spiral_notebook/models/portfolio/portfolio.dart';
import 'package:spiral_notebook/models/shared_artifacts_comments/shared_artifacts_comment.dart';
import 'package:spiral_notebook/models/shared_artifacts_comments/shared_artifacts_comments.dart';
import 'package:spiral_notebook/models/shared_artifacts_reactions/shared_artifacts_reaction.dart';
import 'package:spiral_notebook/models/shared_artifacts_reactions/shared_artifacts_reactions.dart';
import 'package:spiral_notebook/models/shared_portfolio/shared_portfolio.dart';
import 'package:spiral_notebook/models/shared_portfolio/shared_portfolios.dart';

// NOTE: MyPortfolios and SharedPortfolios use a custom Type Adapter, while
// artifacts uses encoded JSON string to store the data.
// Add Artifact/SharedArtifact modifies MyPortfolios/SharedPortfolios, so it is simpler
// to use a custom type adapter rather than manually convert
// the Portfolio/SharedPortfolio to JSON for caching.

class HiveDataStore {
  static const artifactsJSONBoxName = 'artifacts';
  static const sharedArtifactsJSONBoxName = 'shared_artifacts';
  static const currentUserJSONBoxName = 'current_user';
  static const myPortfoliosBoxName = 'my_portfolios';
  static const notificationsListBoxName = 'notifications_list';
  static const sharedArtifactCommentsBoxName = 'shared_artifacts_comments';
  static const sharedArtifactReactionsBoxName = 'shared_artifacts_reactions';
  static const sharedPortfoliosBoxName = 'shared_portfolios';
  static const syncTimestampBoxName = 'sync_time';

  // used for boxes that contain just a single object.
  static const soloBoxKey = '0';

  static String artifactsJSONkey(dynamic key) => 'artifacts/$key';
  static String sharedArtifactsJSONkey(dynamic key) => 'shared_artifacts/$key';

  Future<void> init() async {
    await Hive.initFlutter();
    // register adapters
    Hive.registerAdapter<MyPortfolios>(MyPortfoliosAdapter());
    Hive.registerAdapter<Portfolio>(PortfolioAdapter());
    Hive.registerAdapter<AuthUser>(AuthUserAdapter());
    Hive.registerAdapter<CurrentAuthUser>(CurrentAuthUserAdapter());
    Hive.registerAdapter<SharedArtifactsComment>(SharedArtifactsCommentAdapter());
    Hive.registerAdapter<SharedArtifactsComments>(SharedArtifactsCommentsAdapter());
    Hive.registerAdapter<SharedArtifactsReaction>(SharedArtifactsReactionAdapter());
    Hive.registerAdapter<SharedArtifactsReactions>(SharedArtifactsReactionsAdapter());
    Hive.registerAdapter<SharedPortfolios>(SharedPortfoliosAdapter());
    Hive.registerAdapter<SharedPortfolio>(SharedPortfolioAdapter());
    Hive.registerAdapter<NotificationsListItem>(NotificationsListItemAdapter());
    Hive.registerAdapter<NotificationsList>(NotificationsListAdapter());


    // open boxes
    await Hive.openBox<MyPortfolios>(myPortfoliosBoxName);
    await Hive.openBox<SharedArtifactsComments>(sharedArtifactCommentsBoxName);
    await Hive.openBox<SharedArtifactsReactions>(sharedArtifactReactionsBoxName);
    await Hive.openBox<SharedPortfolios>(sharedPortfoliosBoxName);
    await Hive.openBox(artifactsJSONBoxName);
    await Hive.openBox(sharedArtifactsJSONBoxName);
    await Hive.openBox<DateTime>(syncTimestampBoxName);
    await Hive.openBox<CurrentAuthUser>(currentUserJSONBoxName);
    await Hive.openBox<NotificationsList>(notificationsListBoxName);

  }

  Future<void> setSyncTime({
    required DateTime myTime,
  }) async {
    final box = Hive.box<DateTime>(syncTimestampBoxName);
    await box.put(soloBoxKey, myTime);
  }

  Future<DateTime> getSyncTime() async {
    final box = Hive.box<DateTime>(syncTimestampBoxName);
    final syncTime = box.get(soloBoxKey);
    return syncTime ?? DateTime.now();
  }


  Future<CurrentAuthUser> getCurrentUser() async {
    final box = Hive.box<CurrentAuthUser>(currentUserJSONBoxName);
    final currentUser = box.get(soloBoxKey);
    return currentUser ?? CurrentAuthUser();
  }

  Future<void> setCurrentUser({
    required CurrentAuthUser currentUser,
  }) async {
    final box = Hive.box<CurrentAuthUser>(currentUserJSONBoxName);
    await box.put(soloBoxKey, currentUser);
  }

  Future<void> setMyPortfolios({
    required MyPortfolios myPortfolios,
  }) async {
    final box = Hive.box<MyPortfolios>(myPortfoliosBoxName);
    await box.put(soloBoxKey, myPortfolios);
  }

  Future<MyPortfolios> getMyPortfolios() async {
    final box = Hive.box<MyPortfolios>(myPortfoliosBoxName);
    final myPortfolios = box.get(soloBoxKey);
    return myPortfolios ?? MyPortfolios([]);
  }

  Future<void> setSharedPortfolios({
    required SharedPortfolios sharedPortfolios,
  }) async {
    final box = Hive.box<SharedPortfolios>(sharedPortfoliosBoxName);
    await box.put(soloBoxKey, sharedPortfolios);
  }

  Future<SharedPortfolios> getSharedPortfolios() async {
    final box = Hive.box<SharedPortfolios>(sharedPortfoliosBoxName);
    final sharedPortfolios = box.get(soloBoxKey);
    return sharedPortfolios ?? SharedPortfolios([]);
  }

  Future<void> setSharedArtifactsComments({
    required SharedArtifactsComments comments,
  }) async {
    final box = Hive.box<SharedArtifactsComments>(sharedArtifactCommentsBoxName);
    await box.put(soloBoxKey, comments);
  }

  Future<SharedArtifactsComments> getSharedArtifactsComments() async {
    final box = Hive.box<SharedArtifactsComments>(sharedArtifactCommentsBoxName);
    final comments = box.get(soloBoxKey);
    return comments ?? SharedArtifactsComments([]);
  }

  Future<void> setSharedArtifactsReactions({
    required SharedArtifactsReactions reactions,
  }) async {
    final box = Hive.box<SharedArtifactsReactions>(sharedArtifactReactionsBoxName);
    await box.put(soloBoxKey, reactions);
  }

  Future<SharedArtifactsReactions> getSharedArtifactsReactions() async {
    final box = Hive.box<SharedArtifactsReactions>(sharedArtifactReactionsBoxName);
    final reactions = box.get(soloBoxKey);
    return reactions ?? SharedArtifactsReactions([]);
  }

  Future<List<dynamic>> getArtifactsCachedJSON() async {
    final box = Hive.box(artifactsJSONBoxName);
    final artifactsJSON = box.values.map((e) => jsonDecode(e)).toList();
    return artifactsJSON;
  }

  Future<void> setAllArtifactsJSON({
    required List<dynamic> artifactsJSON,
    bool force = false,
  }) async {
    final box = Hive.box(artifactsJSONBoxName);
    if (box.isEmpty || force == true) {
      await box.clear();
      artifactsJSON.forEach((row) async {
        // insert into cache using custom key based on artifact id.
        // convert to JSON string before storing to prevent
        // type conversion errors.
        await box.put(artifactsJSONkey(row['id']), jsonEncode(row));
      });
    } else {
      print('Box already has ${box.length} items');
    }
  }

  Future<void> setArtifactJSON({
    required Map<String, dynamic> artifactJSON
  }) async {
    final box = Hive.box(artifactsJSONBoxName);
    // convert to JSON string before storing to prevent
    // type conversion errors.
    await box.put(artifactsJSONkey(artifactJSON['id']), jsonEncode(artifactJSON));
  }

  Future<void> removeArtifactById(String artifactId) async {
    final box = Hive.box(artifactsJSONBoxName);
    await box.delete(artifactsJSONkey(artifactId));
  }

  Future<List<dynamic>> getSharedArtifactsCachedJSON() async {
    final box = Hive.box(sharedArtifactsJSONBoxName);
    final artifactsJSON = box.values.map((e) => jsonDecode(e)).toList();
    return artifactsJSON;
  }

  Future<void> setAllSharedArtifactsJSON({
    required List<dynamic> sharedArtifactsJSON,
    bool force = false,
  }) async {
    final box = Hive.box(sharedArtifactsJSONBoxName);
    if (box.isEmpty || force == true) {
      await box.clear();
      sharedArtifactsJSON.forEach((row) async {
        // insert into cache using custom key based on shared artifact id.
        // convert to JSON string before storing to prevent
        // type conversion errors.
        await box.put(sharedArtifactsJSONkey(row['id']), jsonEncode(row));
      });
    } else {
      print('Box already has ${box.length} items');
    }
  }

  Future<void> setSharedArtifactJSON({
    required Map<String, dynamic> sharedArtifactJSON
  }) async {
    final box = Hive.box(sharedArtifactsJSONBoxName);
    // convert to JSON string before storing to prevent
    // type conversion errors.
    await box.put(sharedArtifactsJSONkey(sharedArtifactJSON['id']), jsonEncode(sharedArtifactJSON));
  }

  Future<void> removeSharedArtifactById(String sharedArtifactId) async {
    final box = Hive.box(sharedArtifactsJSONBoxName);
    await box.delete(sharedArtifactsJSONkey(sharedArtifactId));
  }

  Future<void> setNotificationsList({
    required NotificationsList notificationsList,
  }) async {
    final box = Hive.box<NotificationsList>(notificationsListBoxName);
    await box.put(soloBoxKey, notificationsList);
  }

  Future<NotificationsList> getNotificationsList() async {
    final box = Hive.box<NotificationsList>(notificationsListBoxName);
    final notificationsList = box.get(soloBoxKey);
    return notificationsList ?? NotificationsList([]);
  }

  Future<void> clearAllArtifactsJSON() async {
    final box = Hive.box(artifactsJSONBoxName);
    await box.clear();
  }

  Future<void> clearAllSharedArtifactsJSON() async {
    final box = Hive.box(sharedArtifactsJSONBoxName);
    await box.clear();
  }

  Future<void> clearCurrentUser() async {
    final box = Hive.box<CurrentAuthUser>(currentUserJSONBoxName);
    await box.clear();
  }

  Future<void> clearMyPortfolios() async {
    final box = Hive.box<MyPortfolios>(myPortfoliosBoxName);
    await box.clear();
  }

  Future<void> clearNotificationsList() async {
    final box = Hive.box<NotificationsList>(notificationsListBoxName);
    await box.clear();
  }

  Future<void> clearSharedArtifactsComments() async {
    final box = Hive.box<SharedArtifactsComments>(sharedArtifactCommentsBoxName);
    await box.clear();
  }

  Future<void> clearSharedArtifactsReactions() async {
    final box = Hive.box<SharedArtifactsReactions>(sharedArtifactReactionsBoxName);
    await box.clear();
  }

  Future<void> clearSharedPortfolios() async {
    final box = Hive.box<SharedPortfolios>(sharedPortfoliosBoxName);
    await box.clear();
  }

  Future<void> clearSyncTime() async {
    final box = Hive.box<DateTime>(syncTimestampBoxName);
    await box.clear();
  }

}
