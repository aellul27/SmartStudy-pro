import '../database.dart';
import 'package:flutter/widgets.dart';
import 'package:drift/drift.dart';

/// Inserts a new TaskItem into the local drift database.
Future<void> addTask({
  required String title,
  required String subject,
  required int requiredTime,
  DateTime? dueDate,
  required int priority,
  required completed,
  
}) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  await db.into(db.taskItems).insert(
    TaskItemsCompanion.insert(
      title: title,
      subject: subject,
      requiredTime: requiredTime,
      dueDate: dueDate != null ? Value(dueDate) : const Value.absent(),
      priority: priority,
      completed: completed,
    ),
  );

  await db.close();
}