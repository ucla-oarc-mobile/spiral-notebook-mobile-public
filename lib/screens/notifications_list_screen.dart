import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/components/notifications_list/notifications_list_column.dart';
import 'package:spiral_notebook/models/notifications_list/notifications_list.dart';
import 'package:spiral_notebook/providers/multi_providers_manager.dart';
import 'package:spiral_notebook/providers/notifications_list_provider.dart';
import 'package:spiral_notebook/utilities/loading.dart';
import 'package:spiral_notebook/utilities/snackbar.dart';

class NotificationsListScreen extends ConsumerStatefulWidget {
  static String id = 'my_portfolios_screen';

  const NotificationsListScreen();

  @override
  _NotificationsListScreenState createState() =>
      _NotificationsListScreenState();
}

class _NotificationsListScreenState
    extends ConsumerState<NotificationsListScreen> {
  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    final NotificationsList notificationsList =
        ref.watch(notificationsListProvider);

    return Center(
      child: LayoutBuilder(builder:
          (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: NotificationsListColumn(
                notificationsList: notificationsList.notifications),
          ),
        );
      }),
    );
  }

  Future<bool> refresh() async {
    try {
      await Future.delayed(Duration.zero,
          () => showLoading(context, 'Fetching notifications...'));

      bool requiresFullSync = await ref.read(notificationsListProvider.notifier).serverHasNewNotifications();

      if (requiresFullSync) {
        final MultiProviderManager multiProviderManager =
        MultiProviderManager(ref);
        await multiProviderManager.refreshAll();
      }
      dismissLoading(context);
      return true;
    } catch (e) {
      dismissLoading(context);
      String message =
          (e is HttpException) ? e.message : "Couldn't fetch notifications, please try again later.";
      if (e is TimeoutException)
        message = 'Bad network connection, could not fetch notifications.';
      showSnackAlert(context, message);
      return false;
    }
  }
}
