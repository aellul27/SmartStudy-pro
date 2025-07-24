import '../database.dart';
import 'package:flutter/widgets.dart';

Future<List<String>> getAllSubjects(
) async {
  // ensure Flutter bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  // Use Drift's customSelect to get distinct subjects directly from SQL
  final rows = await db.customSelect("SELECT DISTINCT subject FROM task_items WHERE subject IS NOT NULL AND subject != ''").get();
  await db.close();
  return rows.map((row) => row.data['subject'] as String).toList();
}