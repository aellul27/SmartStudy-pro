import '../database.dart';
import 'package:flutter/widgets.dart';
import 'package:drift/drift.dart';

/// Inserts a new EventItem into the local drift database.
Future<void> removeEvent({
  required int id,
}) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final db = getDatabaseInstance();
  await (db.delete(db.eventItems)..where((t) => t.id.equals(id))).go();
  
}

Future<void> removeEventDay({
  required DateTime dayRemove,
}) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final db = getDatabaseInstance();
  final startOfDay = DateTime(dayRemove.year, dayRemove.month, dayRemove.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));
  db.delete(db.eventItems).where((t) => t.startTime.isBetweenValues(startOfDay, endOfDay));
  
}

Future<void> removeEventWeek({
  required DateTime weekRemove,
}) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final weekday = weekRemove.weekday;
  final startOfWeek = DateTime(weekRemove.year, weekRemove.month, weekRemove.day)
      .subtract(Duration(days: weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 7));

  final db = getDatabaseInstance();
  db.delete(db.eventItems).where((t) => t.startTime.isBetweenValues(startOfWeek, endOfWeek));
  
}