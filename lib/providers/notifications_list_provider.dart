import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spiral_notebook/models/notifications_list/notifications_list.dart';
import 'package:spiral_notebook/persistence/hive_data_store.dart';
import 'package:spiral_notebook/services/notifications_list_service.dart';

class NotificationsListManager extends StateNotifier<NotificationsList> {
  final HiveDataStore dataStore;

  NotificationsListManager({
    required NotificationsList notificationsList,
    required this.dataStore,
  }) : super(notificationsList);

  void refreshWithJson(json) {
    state = NotificationsList.fromJson(json);
    dataStore.setNotificationsList(notificationsList: state);
  }

  Future<dynamic> syncNotificationsList() async {
    final NotificationsListService _notifications = NotificationsListService();

    bool syncSuccess = false;

    final notificationsResult = await _notifications.fetchNotificationsList();

    syncSuccess = (notificationsResult != null);

    if (syncSuccess) {
      state = NotificationsList.fromJson(notificationsResult);
      dataStore.setNotificationsList(notificationsList: state);
    }
  }

  void reset() {
    state = NotificationsList([]);
    dataStore.setNotificationsList(notificationsList: state);
  }

  Future<bool> serverHasNewNotifications() async {
    final NotificationsListService _notifications = NotificationsListService();

    bool syncSuccess = false;

    final notificationsResult = await _notifications.fetchNotificationsList();

    syncSuccess = (notificationsResult != null);

    if (syncSuccess) {
      return state.isServerListDifferent(notificationsResult);
    } else {
      // if the network request somehow fails, just assume there are no new notifications
      // and fail silently.
      return false;
    }
  }
}

final notificationsListProvider = StateNotifierProvider<NotificationsListManager, NotificationsList>((ref) {
  throw UnimplementedError();
});
