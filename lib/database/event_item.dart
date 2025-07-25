import 'package:fluent_ui/fluent_ui.dart';
import 'task_item.dart'; // Make sure this import exists

class EventItem {
  final int id;
  final String title;
  final String eventType;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final int? taskId;
  final TaskItem? taskItem; // Optional TaskItem

  EventItem(
    this.id,
    this.title,
    this.eventType,
    this.startTime,
    this.endTime,
    this.color,
    this.taskId, {
    this.taskItem, // Named optional
  });
}