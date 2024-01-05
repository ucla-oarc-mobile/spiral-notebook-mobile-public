import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spiral_notebook/screens/home_tabs_frame.dart';
import 'firebase_options.dart';

import 'package:spiral_notebook/models/artifact/artifacts.dart';
import 'package:spiral_notebook/persistence/hive_data_store.dart';
import 'package:spiral_notebook/providers/artifacts_provider.dart';
import 'package:spiral_notebook/providers/current_user_provider.dart';
import 'package:spiral_notebook/providers/notifications_list_provider.dart';
import 'package:spiral_notebook/providers/my_portfolios_provider.dart';
import 'package:spiral_notebook/providers/shared_artifact_comments_provider.dart';
import 'package:spiral_notebook/providers/shared_artifacts_provider.dart';
import 'package:spiral_notebook/providers/shared_artifacts_reactions_provider.dart';
import 'package:spiral_notebook/providers/shared_portfolios_provider.dart';
import 'package:spiral_notebook/providers/sync_timestamp_provider.dart';

import 'package:spiral_notebook/screens/initial_screen.dart';
import 'package:spiral_notebook/screens/login_screen.dart';
import 'package:spiral_notebook/screens/forgot_password_screen.dart';

import 'package:spiral_notebook/screens/my_portfolios_screen.dart';
import 'package:spiral_notebook/screens/parking_lot_screen.dart';

import 'models/shared_artifact/shared_artifacts.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  final dataStore = HiveDataStore();
  await dataStore.init();
  final initialMyPortfolios = await dataStore.getMyPortfolios();
  final initialSharedArtifactComments = await dataStore.getSharedArtifactsComments();
  final initialSharedArtifactReactions = await dataStore.getSharedArtifactsReactions();
  final initialSharedPortfolios = await dataStore.getSharedPortfolios();
  final initialArtifactsJSON = await dataStore.getArtifactsCachedJSON();
  final initialSharedArtifactsJSON = await dataStore.getSharedArtifactsCachedJSON();
  final initialSyncTime = await dataStore.getSyncTime();
  final initialUser = await dataStore.getCurrentUser();
  final initialNotificationsList = await dataStore.getNotificationsList();

  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(
    overrides: [
      artifactsProvider.overrideWithValue(ArtifactsManager(
        dataStore: dataStore,
        artifacts: Artifacts.fromJson(initialArtifactsJSON),
      )),
      sharedArtifactsProvider.overrideWithValue(SharedArtifactsManager(
        dataStore: dataStore,
        artifacts: SharedArtifacts.fromJson(initialSharedArtifactsJSON),
      )),
      sharedArtifactsCommentsProvider.overrideWithValue(SharedArtifactsCommentsManager(
        dataStore: dataStore,
        comments: initialSharedArtifactComments,
      )),
      sharedArtifactsReactionsProvider.overrideWithValue(SharedArtifactsReactionsManager(
        dataStore: dataStore,
        reactions: initialSharedArtifactReactions,
      )),
      currentUserProvider.overrideWithValue(CurrentUserManager(
        dataStore: dataStore,
        currentUser: initialUser,
      )),
      myPortfoliosProvider.overrideWithValue(PortfoliosManager(
        dataStore: dataStore,
        portfolios: initialMyPortfolios,
      )),
      notificationsListProvider.overrideWithValue(NotificationsListManager(
        dataStore: dataStore,
        notificationsList: initialNotificationsList,
      )),
      sharedPortfoliosProvider.overrideWithValue(SharedPortfoliosManager(
        dataStore: dataStore,
        sharedPortfolios: initialSharedPortfolios,
      )),
      syncTimestampProvider.overrideWithValue(SyncTimestampManager(
        dataStore: dataStore,
        myTime: initialSyncTime,
      )),
    ],
    child: SpiralNotebook(),
  ));
}

class SpiralNotebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Uncomment this for screen shots.
      // debugShowCheckedModeBanner: false,
      initialRoute: InitialScreen.id,
      navigatorKey: navigatorKey,
      title: 'SPIRAL Notebook',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        InitialScreen.id: (context) => InitialScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
        HomeTabsFrame.id: (context) => HomeTabsFrame(),
        MyPortfoliosScreen.id: (context) => MyPortfoliosScreen(),
        ParkingLotScreen.id: (context) => ParkingLotScreen(),
      },
    );
  }
}
