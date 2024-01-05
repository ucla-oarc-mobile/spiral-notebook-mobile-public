
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'notifications_list_item.g.dart';

@HiveType(typeId: 6)
class NotificationsListItem {
  @HiveField(0)
  final String messageId;
  @HiveField(1)
  final String body;
  @HiveField(2)
  final String destination;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4)
  final String title;
  @HiveField(5)
  final bool isRead;

  NotificationsListItem({
    required this.messageId,
    required this.body,
    required this.destination,
    required this.isRead,
    required this.timestamp,
    required this.title,
  });

  String get formattedDayOfMonth {
    var formatter = new DateFormat('MMM d, yyyy');
    String date = formatter.format(timestamp);
    return date;
  }

  String get formattedHourMin {
    var formatter = new DateFormat('h:mp');
    String date = formatter.format(timestamp);
    return date;
  }

  NotificationsListItem.fromJson({required Map<String, dynamic> parsedJson})
      : messageId = "${parsedJson['messageId']}",
        body = "${parsedJson['body']}",
        destination = "${parsedJson['destination']}",
        isRead = parsedJson['viewed'] || false,
        timestamp = DateTime.fromMillisecondsSinceEpoch(parsedJson['sent']),
        title = "${parsedJson['title']}";
}