import 'database.dart';
import 'package:flutter/widgets.dart';
import 'package:drift/drift.dart';

/// Inserts a new EventItem into the local drift database.
Future<void> addEvent({
  required String title,
  required String eventType,
  required DateTime startTime,
  required DateTime endTime,
  required String color,
}) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  await db.into(db.eventItems).insert(
    EventItemsCompanion.insert(
      title: title,
      eventType: eventType,
      startTime: Value(startTime),
      endTime:   Value(endTime),
      color: color,
    ),
  );

  await db.close();
}