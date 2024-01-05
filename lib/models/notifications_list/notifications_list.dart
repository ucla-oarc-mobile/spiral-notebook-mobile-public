
import 'package:hive/hive.dart';
import 'package:spiral_notebook/models/notifications_list/notifications_list_item.dart';

part 'notifications_list.g.dart';

@HiveType(typeId: 7)
class NotificationsList {
  @HiveField(0)
  List<NotificationsListItem> notifications;

  NotificationsList(this.notifications);

  NotificationsListItem getById(String id) => notifications.firstWhere(
        (notification) => notification.messageId == id,
    orElse: () => throw Exception('invalid Notification List Item ID $id'),
  );

  static List<NotificationsListItem> listFromNotifications(List<dynamic> notificationsJson) {
    List<NotificationsListItem> notificationsList = [];

    notificationsJson.forEach((notificationJson) {
      notificationsList.add(NotificationsListItem.fromJson(
        parsedJson: notificationJson,
      ));
    });

    // ensure that all artifacts are sorted by date created. Critical!
    notificationsList.sort((a, b) => (b.timestamp.compareTo(a.timestamp)));
    return notificationsList;
  }

  // // TODO: Add handler here to remove a notification from the list.
  // NotificationList withRemovedNotification(String notificationId) {
  //
  // }

  bool isServerListDifferent(List<dynamic> notificationsJson) {
    List<NotificationsListItem> serverList = listFromNotifications(notificationsJson);

    if (serverList.length != notifications.length) return true;

    // both are the same length, compare all timestamps just in case.
    for (int i=0; i<serverList.length; i++) {
      final NotificationsListItem matchingCachedNotification = notifications[i];
      // both lists are automatically sorted by timestamp, so they should be equivalent.
      if (!serverList[i].timestamp.isAtSameMomentAs(matchingCachedNotification.timestamp)) {
        return true;
      }
    }
    return false;
  }

  NotificationsList.fromJson(List<dynamic> parsedJson)
    : notifications = listFromNotifications(parsedJson);
}