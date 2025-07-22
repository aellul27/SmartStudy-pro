import 'package:fluent_ui/fluent_ui.dart';

class EventItem {
  final int id;
  final String title;
  final String eventType;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  EventItem(this.id, this.title, this.eventType, this.startTime, this.endTime, this.color);
}