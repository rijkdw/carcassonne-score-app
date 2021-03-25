import 'package:intl/intl.dart';

String stringify(DateTime dateTime) {
  // 20:30               same day
  // yesterday, 20:30    yesterday
  // [2-31] days ago, 20:30
  // Last year June
  // for now, do hh:mm DD/MM
  if (dateTime == null) print("null datetime received");
  return DateFormat("hh:mm dd/MM").format(dateTime);
}

String stringifyYear(DateTime dateTime) {
  var now = DateTime.now();
  // if this year
  if (now.year - dateTime.year == 0) return 'this year';
  // if last year
  if (now.year - dateTime.year == 1) return 'last year';
  // if more than a year ago
  return '${dateTime.year}';
}