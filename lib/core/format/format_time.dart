import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormatTime {
  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter =
        DateFormat('MMMM d, yyyy \'at\' h:mm:ss a zzz');
    return formatter.format(dateTime);
  }

  static Timestamp toFirestoreTimestamp({required DateTime dateTime}) {
    return Timestamp.fromDate(dateTime);
  }

  static String formatDate(DateTime? dateTime) {
    final DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(dateTime!);
  }

  static String FormatTimes(DateTime? dateTime) {
    final DateFormat formatter = DateFormat('h:mm:ss');
    return formatter.format(dateTime!);
  }
}
