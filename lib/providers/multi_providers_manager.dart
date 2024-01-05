import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/providers/artifacts_provider.dart';
import 'package:spiral_notebook/providers/current_user_provider.dart';
import 'package:spiral_notebook/providers/my_portfolios_provider.dart';
import 'package:spiral_notebook/providers/notifications_list_provider.dart';
import 'package:spiral_notebook/providers/shared_artifact_comments_provider.dart';
import 'package:spiral_notebook/providers/shared_artifacts_provider.dart';
import 'package:spiral_notebook/providers/shared_artifacts_reactions_provider.dart';
import 'package:spiral_notebook/providers/shared_portfolios_provider.dart';
import 'package:spiral_notebook/providers/sync_timestamp_provider.dart';
import 'package:spiral_notebook/services/auth_service.dart';

class MultiProviderManager {
  // Until there's a more formal way to handle this,
  // using a simple Class-based manager to perform bulk operations
  // on multiple providers.

  final WidgetRef ref;

  MultiProviderManager(
    this.ref,
  ) : super();

  void bootstrapAll(dynamic bootstrapJsonBundle) {
    // bootstrap all providers with a JSON bundle.
    // not async - these operations should all be internal to the app,
    // and Hive is synchronous.
    ref.read(myPortfoliosProvider.notifier).refreshWithJson(bootstrapJsonBundle['portfolios']);
    ref.read(sharedPortfoliosProvider.notifier).refreshWithJson(bootstrapJsonBundle['sharedPortfolios']);
    ref.read(artifactsProvider.notifier).refreshWithJson(bootstrapJsonBundle['artifacts']);
    ref.read(sharedArtifactsProvider.notifier).refreshWithJson(bootstrapJsonBundle['sharedArtifacts']);
    ref.read(sharedArtifactsCommentsProvider.notifier).refreshWithJson(bootstrapJsonBundle['comments']);
    ref.read(sharedArtifactsReactionsProvider.notifier).refreshWithJson(bootstrapJsonBundle['reactions']);
    ref.read(currentUserProvider.notifier).refreshWithJson(bootstrapJsonBundle);
    ref.read(syncTimestampProvider.notifier).refresh(DateTime.now());

    // re-enable once payload has been added to login bundle
    // ref.read(notificationsListProvider.notifier).refreshWithJson(bootstrapJsonBundle['notificationsList']);
  }

  Future<void> refreshAll() async {
    // refresh all providers by syncing them with their API endpoints.

    await ref.read(myPortfoliosProvider.notifier).syncPortfolios();
    await ref.read(sharedPortfoliosProvider.notifier).syncSharedPortfolios();
    await ref.read(artifactsProvider.notifier).syncArtifacts();
    await ref.read(sharedArtifactsProvider.notifier).syncSharedArtifacts();
    await ref.read(sharedArtifactsCommentsProvider.notifier).syncComments();
    await ref.read(sharedArtifactsReactionsProvider.notifier).syncReactions();
    await ref.read(syncTimestampProvider.notifier).refresh(DateTime.now());
    await ref.read(currentUserProvider.notifier).syncCurrentUser();
    await ref.read(notificationsListProvider.notifier).syncNotificationsList();

    // reset login token
    final AuthService _auth = AuthService();
    await _auth.refreshLoginToken();
  }

  void resetAll({required bool resetUserData}) {
    // clear all data providers.

    // not async - these operations should all be internal to the app,
    // and Hive is synchronous.
    ref.read(myPortfoliosProvider.notifier).reset();
    ref.read(sharedPortfoliosProvider.notifier).reset();
    ref.read(artifactsProvider.notifier).reset();
    ref.read(sharedArtifactsProvider.notifier).reset();
    ref.read(sharedArtifactsCommentsProvider.notifier).reset();
    ref.read(sharedArtifactsReactionsProvider.notifier).reset();
    ref.read(syncTimestampProvider.notifier).reset();
    ref.read(notificationsListProvider.notifier).reset();

    // in some situations we may want to clear data without clearing
    // the current user's data.
    if (resetUserData) ref.read(currentUserProvider.notifier).reset();
  }
}