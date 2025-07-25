import '../database.dart';
import 'package:flutter/widgets.dart';
import 'package:drift/drift.dart';


Future<EventItem?> getEventWithId({
  required int idToGet,
}) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final db = getDatabaseInstance();
  final query = db.select(db.eventItems)
    ..where((e) =>
      e.id.equals(idToGet),
    )..limit(1);
  final items = await query.get();
  
  return items.isNotEmpty ? items.first : null;
}
/// Get EventItems into the local drift database.
Future<List<EventItem>> getAllEvents(
) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final db = getDatabaseInstance();
  final items = await db.select(db.eventItems).get();
    
  return items;
}

/// Get EventItems into the local drift database.
Future<List<EventItem>> getAllEventsDay({
  required DateTime daySearch,
}) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final db = getDatabaseInstance();
  // filter by exact day
  final startOfDay = DateTime(daySearch.year, daySearch.month, daySearch.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));
  final query = db.select(db.eventItems)
    ..where((e) =>
      e.startTime.isBetweenValues(startOfDay, endOfDay)
    );
  final items = await query.get();
  
  return items;
}

/// Get EventItems into the local drift database.
Future<List<EventItem>> getAllEventsWeek({
  required DateTime weekSearch,
}) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final db = getDatabaseInstance();
  // filter by week
  final weekday = weekSearch.weekday;
  final startOfWeek = DateTime(weekSearch.year, weekSearch.month, weekSearch.day)
      .subtract(Duration(days: weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 7));
  final query = db.select(db.eventItems)
    ..where((e) =>
      e.startTime.isBetweenValues(startOfWeek, endOfWeek)
    );
  final items = await query.get();
  
  return items;
}