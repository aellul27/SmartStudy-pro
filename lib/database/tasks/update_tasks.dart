import '../database.dart';
import 'package:flutter/widgets.dart';
import 'package:drift/drift.dart';

/// Updates a TaskItem in the local drift database.
Future<void> updateTask({
  required int id,
  required String title,
  required String subject,
  required int requiredTime,
  DateTime? dueDate,
  required int priority,
  required bool completed,
}) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  await (db.update(db.taskItems)
      ..where((tbl) => tbl.id.equals(id)))
    .write(
      TaskItemsCompanion(
        title: Value(title),
        subject: Value(subject),
        requiredTime: Value(requiredTime),
        dueDate: dueDate != null ? Value(dueDate) : const Value.absent(),
        priority: Value(priority),
        completed: Value(completed),
      ),
    );
  await db.close();
}