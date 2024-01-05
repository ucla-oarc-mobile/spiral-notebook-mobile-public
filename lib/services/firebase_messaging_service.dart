
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:spiral_notebook/main.dart';
import 'package:spiral_notebook/screens/home_tabs_frame.dart';
import 'package:spiral_notebook/services/auth_service.dart';

class FirebaseMessagingService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void init() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    // Get the token each time we initialize messaging
    String? token = await messaging.getToken();
    print('FCM token: $token');

    if (Platform.isIOS) {
      // iOS: show notifications in foreground
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    if (Platform.isAndroid) {
      // Android: set up default channel to highest priority
      await FlutterNotificationChannel.registerNotificationChannel(
        id: 'default',
        name: 'Default',
        description: 'Notifications',
        importance: NotificationImportance.IMPORTANCE_HIGH,
        visibility: NotificationVisibility.VISIBILITY_PUBLIC,
        enableVibration: true,
        enableSound: true,
        showBadge: true,
      );
      _initAndroidForegroundNotifications();
    }

    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    _handleInitialMessage(initialMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_routeToNotificationList);
  }

  void _routeToNotificationList(RemoteMessage message) async {
    AuthService _auth = AuthService();

    // We should only perform any routing if they are logged in. Otherwise
    // do nothing.
    var isLoggedIn = await _auth.isLoggedIn();

    if (isLoggedIn && navigatorKey.currentContext != null) {
      Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) => HomeTabsFrame(
        tabSelection: InitialTabSelection.notifications,
      )));
    }
  }

  void _handleInitialMessage(RemoteMessage? initialMessage) {
    // handle any incoming Firebase push messages when the app launches from
    // an inactive state

    if (initialMessage != null && navigatorKey.currentContext != null) {
      // call initialScreen route with a custom initialTab parameter.
      // pass this parameter down the chain - and allow initialScreen
      // to do its own checking and setup
      _routeToNotificationList(initialMessage);
    }
  }

  void _initAndroidForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        showDialog<void>(
          // must use special context here, since initial screen
          // get wiped immediately.
            context: navigatorKey.currentContext!,
            barrierDismissible: true, // user can tap anywhere to dismiss
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text(notification.title!),
                content: Text(notification.body!),
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
    });
  }


}
