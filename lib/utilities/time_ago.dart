import 'package:intl/intl.dart';

class TimeAgo{
  static String timeAgoSinceDate(DateTime targetDate, {bool numericDates = false}) {
    final dateNow = DateTime.now();
    final difference = dateNow.difference(targetDate);

    if (difference.inDays > 8) {
      var formatter = new DateFormat('EEE, MMM d, yyyy');
      String dateString = formatter.format(targetDate);
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 5) {
      return 'Less than a minute ago';
    } else {
      return 'Just now';
    }
  }

}