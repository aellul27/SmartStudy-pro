import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

import '../database.dart';
/// Desktop/mobile: Dumps the current database and lets the user choose a save location using saveFile().
Future<void> dumpDatabaseWithSaveFile() async {
  Uint8List? bytes;
  final db = getDatabaseInstance();
  final tempDir = Directory.systemTemp;
  final tempFile = File('${tempDir.path}/smartstudy_backup_temp.db');
  if (await tempFile.exists()) {
    await tempFile.delete();
  }
  await db.customStatement('VACUUM INTO ?', [tempFile.absolute.path]);
  bytes = await tempFile.readAsBytes();
  await tempFile.delete();

  // Prompt user for save location
  await FilePicker.platform.saveFile(
    dialogTitle: 'Save database backup',
    fileName: 'smartstudy_backup.db',
    bytes: bytes,
  );
}

/// Desktop/mobile: Imports a backup database into the current database.
Future<void> importDatabaseWithSaveFile() async {
  final backupFile = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['db']);
  if (backupFile == null || backupFile.files.isEmpty || backupFile.files.first.path == null) return;
  final backupPath = backupFile.files.first.path!;

  // Get the path to the main database file
  final db = getDatabaseInstance();

  // Attach the backup database
  await db.customStatement("ATTACH DATABASE ? AS backup", [backupPath]);
  // Copy all data from backup to main
  final tables = await db.customSelect("SELECT name FROM backup.sqlite_master WHERE type='table'").get();
  for (final row in tables) {
    final tableName = row.read<String>('name');
    if (tableName == 'sqlite_sequence') continue;
    await db.customStatement('DELETE FROM $tableName');
    await db.customStatement('INSERT INTO $tableName SELECT * FROM backup.$tableName');
  }
  // Detach the backup
  await db.customStatement("DETACH DATABASE backup");
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