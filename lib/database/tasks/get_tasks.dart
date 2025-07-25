import '../database.dart';
import 'package:flutter/widgets.dart';
import 'package:drift/drift.dart';

/// Get all TaskItems with a specific subject (case-insensitive), optionally filtered by week.
Future<List<TaskItem>> getAllTasksSubject({
  required String subject,
  DateTime? week,
}) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final db = getDatabaseInstance();
  final query = db.select(db.taskItems)
    ..where((t) {
      final subjectMatch = t.subject.lower().equals(subject.toLowerCase());
      if (week != null) {
        final weekday = week.weekday;
        final startOfWeek = DateTime(week.year, week.month, week.day)
            .subtract(Duration(days: weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 7));
        return subjectMatch & t.dueDate.isNotNull() & t.dueDate.isBiggerOrEqualValue(startOfWeek) & t.dueDate.isSmallerThanValue(endOfWeek);
      }
      return subjectMatch;
    });
  final items = await query.get();
  
  return items;
}

/// Get all TaskItems with a specific priority value, optionally filtered by week.
Future<List<TaskItem>> getAllTasksPriority({
  required int priority,
  DateTime? week,
}) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final db = getDatabaseInstance();
  final query = db.select(db.taskItems)
    ..where((t) {
      final priorityMatch = t.priority.equals(priority);
      if (week != null) {
        final weekday = week.weekday;
        final startOfWeek = DateTime(week.year, week.month, week.day)
            .subtract(Duration(days: weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 7));
        return priorityMatch & t.dueDate.isNotNull() & t.dueDate.isBiggerOrEqualValue(startOfWeek) & t.dueDate.isSmallerThanValue(endOfWeek);
      }
      return priorityMatch;
    });
  final items = await query.get();
  
  return items;
}

/// Get all TaskItems filtered by completion status, optionally filtered by week.
Future<List<TaskItem>> getAllTasksCompleted({
  required bool completed,
  DateTime? week,
}) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final db = getDatabaseInstance();
  final query = db.select(db.taskItems)
    ..where((t) {
      final completedMatch = t.completed.equals(completed);
      if (week != null) {
        final weekday = week.weekday;
        final startOfWeek = DateTime(week.year, week.month, week.day)
            .subtract(Duration(days: weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 7));
        return completedMatch & t.dueDate.isNotNull() & t.dueDate.isBiggerOrEqualValue(startOfWeek) & t.dueDate.isSmallerThanValue(endOfWeek);
      }
      return completedMatch;
    });
  final items = await query.get();
  
  return items;
}