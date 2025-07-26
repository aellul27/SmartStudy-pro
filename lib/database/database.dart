import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class EventItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 512)();
  TextColumn get eventType => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  TextColumn get color => text()();
  IntColumn get taskId => integer().nullable().references(TaskItems, #id)();
}

class TaskItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 512)();
  TextColumn get subject => text()();
  IntColumn get requiredTime => integer()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  IntColumn get priority => integer()();
  BoolColumn get completed => boolean()();
}


@DriftDatabase(tables: [EventItems, TaskItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          // Always ensure all tables exist before opening, even if schemaVersion is unchanged
          final m = Migrator(this);
          await m.createAll();
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'AppDatabase',
      native: const DriftNativeOptions(
          // By default, `driftDatabase` from `package:drift_flutter` stores the
          // database files in `getApplicationDocumentsDirectory()`.
          databaseDirectory: getApplicationSupportDirectory,  
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}

// Singleton instance for AppDatabase
AppDatabase? _dbInstance;

AppDatabase getDatabaseInstance({bool reset = false}) {
  if (reset || _dbInstance == null) {
    _dbInstance = AppDatabase();
  }
  return _dbInstance!;
}