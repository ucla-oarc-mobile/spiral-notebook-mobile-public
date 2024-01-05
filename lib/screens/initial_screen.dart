import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/providers/multi_providers_manager.dart';
import 'package:spiral_notebook/screens/home_tabs_frame.dart';
import 'package:spiral_notebook/screens/login_screen.dart';
import 'package:spiral_notebook/services/app_data_version_service.dart';
import 'package:spiral_notebook/services/auth_service.dart';
import 'package:spiral_notebook/services/firebase_messaging_service.dart';
import 'package:spiral_notebook/utilities/constants.dart';

class InitialScreen extends ConsumerStatefulWidget {
  static String id = "initial_screen";

  const InitialScreen({Key? key}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends ConsumerState<InitialScreen> {

  void showUpdateDialog() {
    showDialog<void>(
        context: context,
        barrierDismissible: true, // user can tap anywhere to dismiss
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("What's New"),
            content: Text(dataVersionUpdateMessage),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  void checkLoginStatus() async {
    AuthService _auth = AuthService();
    var isLoggedIn = await _auth.isLoggedIn();

    String userStartScreen = (isLoggedIn)
        ? HomeTabsFrame.id
        : LoginScreen.id;

    // navigate to initial route ASAP, save other processing for later.
    Navigator.pushNamedAndRemoveUntil(context, userStartScreen, (route) => false);

    if (isLoggedIn) {
      checkAppDataVersion();
    }
  }

  void checkAppDataVersion() {
    // check that versions match, show alert and clear cache if mismatching.
    AppDataVersionService _version = AppDataVersionService();

    if (_version.versionConflicts()) {
      _version.overwriteVersionCache();
      // show dialog alert that app data has been updated. They can pull to refresh.
      showUpdateDialog();
      // clear all local data.
      final MultiProviderManager multiProviderManager = MultiProviderManager(ref);
      multiProviderManager.resetAll(resetUserData: false);
    }
  }


  @override
  void initState() {
    super.initState();
    checkLoginStatus();

    // Firebase init should DEFINITELY go at the end of this method -
    // once it initializes, it could potentially perform routing to the
    // Notification tab on the Dashboard screen.
    FirebaseMessagingService _firebase = FirebaseMessagingService();
    _firebase.init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: buttonBGDisabledGrey, child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: Hero(
            tag: 'logo',
            child: Container(
              child: Image.asset(
                'images/logo/login-logo.png',
                semanticLabel: "Spiral Notebook",
              ),
            ),
          ),
        ),
        Center(child: CircularProgressIndicator()),
      ],
    ));
  }
}
