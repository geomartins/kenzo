import 'package:timeago/timeago.dart' as timeago;

class Dates {
  String timeInSeconds(DateTime value) {
    return timeago.format(value);
  }
}
