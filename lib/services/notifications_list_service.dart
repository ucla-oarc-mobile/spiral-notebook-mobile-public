import 'package:spiral_notebook/api/eqis_api.dart';


class NotificationsListService {
  final _notifications = EqisAPI();

  Future<List<dynamic>>? fetchNotificationsList() async {
    final sharedPortfolios = await _notifications.fetchNotificationsList();
    print(sharedPortfolios.runtimeType);
    return sharedPortfolios;
  }

  Future<bool> markAsRead(messageId) async {
    final bool successful = await _notifications.markAsRead(messageId);
    return successful;
  }
}