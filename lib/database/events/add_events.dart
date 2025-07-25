import '../database.dart';
import 'package:flutter/widgets.dart';
import 'package:drift/drift.dart';

/// Inserts a new EventItem into the local drift database.
/// Returns the id of the created event.
Future<int> addEvent({
  required String title,
  required String eventType,
  required DateTime startTime,
  required DateTime endTime,
  required String color,
  int? taskId,
}) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final db = getDatabaseInstance();
  final id = await db.into(db.eventItems).insert(
    EventItemsCompanion.insert(
      title: title,
      eventType: eventType,
      startTime: startTime,
      endTime: endTime,
      color: color,
      taskId: taskId != null ? Value(taskId) : const Value.absent(),
    ),
  );

  return id;
}