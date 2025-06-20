import 'database.dart';
import 'package:flutter/widgets.dart';
import 'package:drift/drift.dart';

/// Inserts a new EventItem into the local drift database.
Future<void> updateEvent({
  required int id,
  required String title,
  required String eventType,
  DateTime? startTime,
  DateTime? endTime,
  required String color,
}) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  await (db.update(db.eventItems)
      ..where((tbl) => tbl.id.equals(id)))
    .write(
      EventItemsCompanion(
        title:    Value(title),
        eventType: Value(eventType),
        startTime: Value(startTime),
        endTime:   Value(endTime),
        color:     Value(color),
      ),
    );
  await db.close();
}