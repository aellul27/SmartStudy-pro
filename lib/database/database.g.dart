// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $EventItemsTable extends EventItems
    with TableInfo<$EventItemsTable, EventItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 512,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    eventType,
    startTime,
    endTime,
    color,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventItem(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      eventType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}event_type'],
          )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      ),
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      color:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}color'],
          )!,
    );
  }

  @override
  $EventItemsTable createAlias(String alias) {
    return $EventItemsTable(attachedDatabase, alias);
  }
}

class EventItem extends DataClass implements Insertable<EventItem> {
  final int id;
  final String title;
  final String eventType;
  final DateTime? startTime;
  final DateTime? endTime;
  final String color;
  const EventItem({
    required this.id,
    required this.title,
    required this.eventType,
    this.startTime,
    this.endTime,
    required this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['event_type'] = Variable<String>(eventType);
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<DateTime>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['color'] = Variable<String>(color);
    return map;
  }

  EventItemsCompanion toCompanion(bool nullToAbsent) {
    return EventItemsCompanion(
      id: Value(id),
      title: Value(title),
      eventType: Value(eventType),
      startTime:
          startTime == null && nullToAbsent
              ? const Value.absent()
              : Value(startTime),
      endTime:
          endTime == null && nullToAbsent
              ? const Value.absent()
              : Value(endTime),
      color: Value(color),
    );
  }

  factory EventItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventItem(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      eventType: serializer.fromJson<String>(json['eventType']),
      startTime: serializer.fromJson<DateTime?>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      color: serializer.fromJson<String>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'eventType': serializer.toJson<String>(eventType),
      'startTime': serializer.toJson<DateTime?>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'color': serializer.toJson<String>(color),
    };
  }

  EventItem copyWith({
    int? id,
    String? title,
    String? eventType,
    Value<DateTime?> startTime = const Value.absent(),
    Value<DateTime?> endTime = const Value.absent(),
    String? color,
  }) => EventItem(
    id: id ?? this.id,
    title: title ?? this.title,
    eventType: eventType ?? this.eventType,
    startTime: startTime.present ? startTime.value : this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    color: color ?? this.color,
  );
  EventItem copyWithCompanion(EventItemsCompanion data) {
    return EventItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('eventType: $eventType, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, eventType, startTime, endTime, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.eventType == this.eventType &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.color == this.color);
}

class EventItemsCompanion extends UpdateCompanion<EventItem> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> eventType;
  final Value<DateTime?> startTime;
  final Value<DateTime?> endTime;
  final Value<String> color;
  const EventItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.eventType = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.color = const Value.absent(),
  });
  EventItemsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String eventType,
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    required String color,
  }) : title = Value(title),
       eventType = Value(eventType),
       color = Value(color);
  static Insertable<EventItem> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? eventType,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (eventType != null) 'event_type': eventType,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (color != null) 'color': color,
    });
  }

  EventItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? eventType,
    Value<DateTime?>? startTime,
    Value<DateTime?>? endTime,
    Value<String>? color,
  }) {
    return EventItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      eventType: eventType ?? this.eventType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('eventType: $eventType, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EventItemsTable eventItems = $EventItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [eventItems];
}

typedef $$EventItemsTableCreateCompanionBuilder =
    EventItemsCompanion Function({
      Value<int> id,
      required String title,
      required String eventType,
      Value<DateTime?> startTime,
      Value<DateTime?> endTime,
      required String color,
    });
typedef $$EventItemsTableUpdateCompanionBuilder =
    EventItemsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> eventType,
      Value<DateTime?> startTime,
      Value<DateTime?> endTime,
      Value<String> color,
    });

class $$EventItemsTableFilterComposer
    extends Composer<_$AppDatabase, $EventItemsTable> {
  $$EventItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventItemsTable> {
  $$EventItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventItemsTable> {
  $$EventItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$EventItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventItemsTable,
          EventItem,
          $$EventItemsTableFilterComposer,
          $$EventItemsTableOrderingComposer,
          $$EventItemsTableAnnotationComposer,
          $$EventItemsTableCreateCompanionBuilder,
          $$EventItemsTableUpdateCompanionBuilder,
          (
            EventItem,
            BaseReferences<_$AppDatabase, $EventItemsTable, EventItem>,
          ),
          EventItem,
          PrefetchHooks Function()
        > {
  $$EventItemsTableTableManager(_$AppDatabase db, $EventItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$EventItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$EventItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$EventItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<DateTime?> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<String> color = const Value.absent(),
              }) => EventItemsCompanion(
                id: id,
                title: title,
                eventType: eventType,
                startTime: startTime,
                endTime: endTime,
                color: color,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String eventType,
                Value<DateTime?> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                required String color,
              }) => EventItemsCompanion.insert(
                id: id,
                title: title,
                eventType: eventType,
                startTime: startTime,
                endTime: endTime,
                color: color,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventItemsTable,
      EventItem,
      $$EventItemsTableFilterComposer,
      $$EventItemsTableOrderingComposer,
      $$EventItemsTableAnnotationComposer,
      $$EventItemsTableCreateCompanionBuilder,
      $$EventItemsTableUpdateCompanionBuilder,
      (EventItem, BaseReferences<_$AppDatabase, $EventItemsTable, EventItem>),
      EventItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EventItemsTableTableManager get eventItems =>
      $$EventItemsTableTableManager(_db, _db.eventItems);
}
