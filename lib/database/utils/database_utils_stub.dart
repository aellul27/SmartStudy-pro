// Stub for unsupported platforms (should not be used)
Future<void> dumpDatabaseWithSaveFile() async {
  throw UnsupportedError('Not implemented for this platform');
}

Future<void> importDatabaseWithSaveFile() async {
  throw UnsupportedError('Not implemented for this platform');
}
/// Drops all tables in the database (deletes all data, but keeps the file).
Future<void> dropAllTables() async {
  throw UnsupportedError('Not implemented for this platform');
}
