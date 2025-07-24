import 'package:drift/wasm.dart';
import 'package:file_picker/file_picker.dart';
import '../database.dart';

/// Dumps the current database and lets the user choose a save location using saveFile().
Future<void> dumpDatabaseWithSaveFile() async {
  final probe = await WasmDatabase.probe(
    sqlite3Uri: Uri.parse('sqlite3.wasm'),
    driftWorkerUri: Uri.parse('drift_worker.js'),
    databaseName: 'AppDatabase',
  );
  final exportedBytes = await probe.exportDatabase(probe.existingDatabases[0]);
  await FilePicker.platform.saveFile(
    dialogTitle: 'Save database backup',
    fileName: 'smartstudy_backup.db',
    bytes: exportedBytes,
  );
}

Future<void> importDatabaseWithSaveFile() async {
  var picked = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['db']);
  if (picked != null) {
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
  }
}

/// Deletes all rows from all user tables in the database (keeps the tables and file).
Future<void> dropAllTables() async {
  final db = AppDatabase();
  // Get all user tables
  final tables = await db.customSelect("SELECT name FROM sqlite_master WHERE type='table'").get();
  for (final row in tables) {
    final tableName = row.read<String>('name');
    if (tableName == 'sqlite_sequence' || tableName.startsWith('sqlite_')) continue;
    await db.customStatement('DELETE FROM $tableName');
  }
  await db.close();
}