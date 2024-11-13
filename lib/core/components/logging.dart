import 'dart:developer';

@Deprecated('please use ```Log.i()```')
void dlg(dynamic string) {
  log(string.toString());
}

class Log {
  static void i(String tag, dynamic msg) =>
      log("[i][$tag] --> ${msg.toString()}");
  static void d(String tag, dynamic msg) =>
      log("[d][$tag] --> ${msg.toString()}");
  static void e(String tag, dynamic msg) =>
      log("[e][$tag] --> ${msg.toString()}");
}
