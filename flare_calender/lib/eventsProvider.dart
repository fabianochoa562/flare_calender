import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'eventData.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
// ignore: prefer_mixin
class EventsProvider with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;
  //the events list will hold a DateTime value and a string value
  //'DateTime: select_day , String: event_name ]
  List<eventData> events_list = [];

  int get count => _count;

  void event_create(String event_name, DateTime event_date) {
    events_list.add(eventData(title: event_name, date: event_date));
  }

  void event_remove() {}
  void events_list_clear() {
    events_list.clear();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
}
