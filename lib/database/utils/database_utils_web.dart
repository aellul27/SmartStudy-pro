import 'package:drift/wasm.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../database.dart';

/// Dumps the current database and lets the user choose a save location using saveFile().
Future<void> dumpDatabaseWithSaveFile({BuildContext? context}) async {
  final db = getDatabaseInstance();
  await db.close();
  final probe = await WasmDatabase.probe(
    sqlite3Uri: Uri.parse('sqlite3.wasm'),
    driftWorkerUri: Uri.parse('drift_worker.js'),
    databaseName: 'AppDatabase',
  );
  if (probe.existingDatabases.isEmpty) {
    getDatabaseInstance(reset: true);
    return;
  }
  final exportedBytes = await probe.exportDatabase(probe.existingDatabases[0]);
  await FilePicker.platform.saveFile(
    dialogTitle: 'Save database backup',
    fileName: 'smartstudy_backup.db',
    bytes: exportedBytes,
  );
  getDatabaseInstance(reset: true);
}

Future<void> importDatabaseWithSaveFile({BuildContext? context}) async {
  final picked = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['db']);
  // Wait until the user has picked a file, and return early if cancelled or invalid
  if (picked == null || picked.files.isEmpty || picked.files.first.bytes == null) {
    return;
  }
  final db = getDatabaseInstance();
  await db.close();
  final probe = await WasmDatabase.probe(
    sqlite3Uri: Uri.parse('sqlite3.wasm'),
    driftWorkerUri: Uri.parse('drift_worker.js'),
    databaseName: 'AppDatabase',
  );
  if (probe.existingDatabases.isNotEmpty) {
    await probe.deleteDatabase(probe.existingDatabases[0]);
  }
  await WasmDatabase.open(
    databaseName: 'AppDatabase',
    sqlite3Uri: Uri.parse('sqlite3.wasm'),
    driftWorkerUri: Uri.parse('drift_worker.js'),
    initializeDatabase: () async {
      return picked.files.first.bytes;
    },
  );
  getDatabaseInstance(reset: true);
}

/// Deletes all rows from all user tables in the database (keeps the tables and file).
Future<void> dropAllTables() async {
  final db = getDatabaseInstance();
  // Get all user tables
  final tables = await db.customSelect("SELECT name FROM sqlite_master WHERE type='table'").get();
  for (final row in tables) {
    final tableName = row.read<String>('name');
    if (tableName == 'sqlite_sequence' || tableName.startsWith('sqlite_')) continue;
    await db.customStatement('DELETE FROM $tableName');
  }
  
}