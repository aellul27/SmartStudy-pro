// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TaskItemsTable extends TaskItems
    with TableInfo<$TaskItemsTable, TaskItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requiredTimeMeta = const VerificationMeta(
    'requiredTime',
  );
  @override
  late final GeneratedColumn<int> requiredTime = GeneratedColumn<int>(
    'required_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    subject,
    requiredTime,
    dueDate,
    priority,
    completed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskItem> instance, {
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
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('required_time')) {
      context.handle(
        _requiredTimeMeta,
        requiredTime.isAcceptableOrUnknown(
          data['required_time']!,
          _requiredTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requiredTimeMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    } else if (isInserting) {
      context.missing(_completedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskItem(
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
      subject:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}subject'],
          )!,
      requiredTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}required_time'],
          )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      priority:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}priority'],
          )!,
      completed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}completed'],
          )!,
    );
  }

  @override
  $TaskItemsTable createAlias(String alias) {
    return $TaskItemsTable(attachedDatabase, alias);
  }
}

class TaskItem extends DataClass implements Insertable<TaskItem> {
  final int id;
  final String title;
  final String subject;
  final int requiredTime;
  final DateTime? dueDate;
  final int priority;
  final bool completed;
  const TaskItem({
    required this.id,
    required this.title,
    required this.subject,
    required this.requiredTime,
    this.dueDate,
    required this.priority,
    required this.completed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['subject'] = Variable<String>(subject);
    map['required_time'] = Variable<int>(requiredTime);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['priority'] = Variable<int>(priority);
    map['completed'] = Variable<bool>(completed);
    return map;
  }

  TaskItemsCompanion toCompanion(bool nullToAbsent) {
    return TaskItemsCompanion(
      id: Value(id),
      title: Value(title),
      subject: Value(subject),
      requiredTime: Value(requiredTime),
      dueDate:
          dueDate == null && nullToAbsent
              ? const Value.absent()
              : Value(dueDate),
      priority: Value(priority),
      completed: Value(completed),
    );
  }

  factory TaskItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskItem(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      subject: serializer.fromJson<String>(json['subject']),
      requiredTime: serializer.fromJson<int>(json['requiredTime']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      priority: serializer.fromJson<int>(json['priority']),
      completed: serializer.fromJson<bool>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'subject': serializer.toJson<String>(subject),
      'requiredTime': serializer.toJson<int>(requiredTime),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'priority': serializer.toJson<int>(priority),
      'completed': serializer.toJson<bool>(completed),
    };
  }

  TaskItem copyWith({
    int? id,
    String? title,
    String? subject,
    int? requiredTime,
    Value<DateTime?> dueDate = const Value.absent(),
    int? priority,
    bool? completed,
  }) => TaskItem(
    id: id ?? this.id,
    title: title ?? this.title,
    subject: subject ?? this.subject,
    requiredTime: requiredTime ?? this.requiredTime,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    priority: priority ?? this.priority,
    completed: completed ?? this.completed,
  );
  TaskItem copyWithCompanion(TaskItemsCompanion data) {
    return TaskItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      subject: data.subject.present ? data.subject.value : this.subject,
      requiredTime:
          data.requiredTime.present
              ? data.requiredTime.value
              : this.requiredTime,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      priority: data.priority.present ? data.priority.value : this.priority,
      completed: data.completed.present ? data.completed.value : this.completed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subject: $subject, ')
          ..write('requiredTime: $requiredTime, ')
          ..write('dueDate: $dueDate, ')
          ..write('priority: $priority, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    subject,
    requiredTime,
    dueDate,
    priority,
    completed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.subject == this.subject &&
          other.requiredTime == this.requiredTime &&
          other.dueDate == this.dueDate &&
          other.priority == this.priority &&
          other.completed == this.completed);
}

class TaskItemsCompanion extends UpdateCompanion<TaskItem> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> subject;
  final Value<int> requiredTime;
  final Value<DateTime?> dueDate;
  final Value<int> priority;
  final Value<bool> completed;
  const TaskItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.subject = const Value.absent(),
    this.requiredTime = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.priority = const Value.absent(),
    this.completed = const Value.absent(),
  });
  TaskItemsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String subject,
    required int requiredTime,
    this.dueDate = const Value.absent(),
    required int priority,
    required bool completed,
  }) : title = Value(title),
       subject = Value(subject),
       requiredTime = Value(requiredTime),
       priority = Value(priority),
       completed = Value(completed);
  static Insertable<TaskItem> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? subject,
    Expression<int>? requiredTime,
    Expression<DateTime>? dueDate,
    Expression<int>? priority,
    Expression<bool>? completed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (subject != null) 'subject': subject,
      if (requiredTime != null) 'required_time': requiredTime,
      if (dueDate != null) 'due_date': dueDate,
      if (priority != null) 'priority': priority,
      if (completed != null) 'completed': completed,
    });
  }

  TaskItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? subject,
    Value<int>? requiredTime,
    Value<DateTime?>? dueDate,
    Value<int>? priority,
    Value<bool>? completed,
  }) {
    return TaskItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      requiredTime: requiredTime ?? this.requiredTime,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
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
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (requiredTime.present) {
      map['required_time'] = Variable<int>(requiredTime.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subject: $subject, ')
          ..write('requiredTime: $requiredTime, ')
          ..write('dueDate: $dueDate, ')
          ..write('priority: $priority, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }
}

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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_items (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    eventType,
    startTime,
    endTime,
    color,
    taskId,
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
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
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
      startTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}start_time'],
          )!,
      endTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}end_time'],
          )!,
      color:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}color'],
          )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      ),
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
  final DateTime startTime;
  final DateTime endTime;
  final String color;
  final int? taskId;
  const EventItem({
    required this.id,
    required this.title,
    required this.eventType,
    required this.startTime,
    required this.endTime,
    required this.color,
    this.taskId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['event_type'] = Variable<String>(eventType);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['color'] = Variable<String>(color);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<int>(taskId);
    }
    return map;
  }

  EventItemsCompanion toCompanion(bool nullToAbsent) {
    return EventItemsCompanion(
      id: Value(id),
      title: Value(title),
      eventType: Value(eventType),
      startTime: Value(startTime),
      endTime: Value(endTime),
      color: Value(color),
      taskId:
          taskId == null && nullToAbsent ? const Value.absent() : Value(taskId),
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
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      color: serializer.fromJson<String>(json['color']),
      taskId: serializer.fromJson<int?>(json['taskId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'eventType': serializer.toJson<String>(eventType),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'color': serializer.toJson<String>(color),
      'taskId': serializer.toJson<int?>(taskId),
    };
  }

  EventItem copyWith({
    int? id,
    String? title,
    String? eventType,
    DateTime? startTime,
    DateTime? endTime,
    String? color,
    Value<int?> taskId = const Value.absent(),
  }) => EventItem(
    id: id ?? this.id,
    title: title ?? this.title,
    eventType: eventType ?? this.eventType,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    color: color ?? this.color,
    taskId: taskId.present ? taskId.value : this.taskId,
  );
  EventItem copyWithCompanion(EventItemsCompanion data) {
    return EventItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      color: data.color.present ? data.color.value : this.color,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
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
          ..write('color: $color, ')
          ..write('taskId: $taskId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, eventType, startTime, endTime, color, taskId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.eventType == this.eventType &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.color == this.color &&
          other.taskId == this.taskId);
}

class EventItemsCompanion extends UpdateCompanion<EventItem> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> eventType;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<String> color;
  final Value<int?> taskId;
  const EventItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.eventType = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.color = const Value.absent(),
    this.taskId = const Value.absent(),
  });
  EventItemsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String eventType,
    required DateTime startTime,
    required DateTime endTime,
    required String color,
    this.taskId = const Value.absent(),
  }) : title = Value(title),
       eventType = Value(eventType),
       startTime = Value(startTime),
       endTime = Value(endTime),
       color = Value(color);
  static Insertable<EventItem> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? eventType,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? color,
    Expression<int>? taskId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (eventType != null) 'event_type': eventType,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (color != null) 'color': color,
      if (taskId != null) 'task_id': taskId,
    });
  }

  EventItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? eventType,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<String>? color,
    Value<int?>? taskId,
  }) {
    return EventItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      eventType: eventType ?? this.eventType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      taskId: taskId ?? this.taskId,
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
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
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
          ..write('color: $color, ')
          ..write('taskId: $taskId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TaskItemsTable taskItems = $TaskItemsTable(this);
  late final $EventItemsTable eventItems = $EventItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [taskItems, eventItems];
}

typedef $$TaskItemsTableCreateCompanionBuilder =
    TaskItemsCompanion Function({
      Value<int> id,
      required String title,
      required String subject,
      required int requiredTime,
      Value<DateTime?> dueDate,
      required int priority,
      required bool completed,
    });
typedef $$TaskItemsTableUpdateCompanionBuilder =
    TaskItemsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> subject,
      Value<int> requiredTime,
      Value<DateTime?> dueDate,
      Value<int> priority,
      Value<bool> completed,
    });

final class $$TaskItemsTableReferences
    extends BaseReferences<_$AppDatabase, $TaskItemsTable, TaskItem> {
  $$TaskItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EventItemsTable, List<EventItem>>
  _eventItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.eventItems,
    aliasName: $_aliasNameGenerator(db.taskItems.id, db.eventItems.taskId),
  );

  $$EventItemsTableProcessedTableManager get eventItemsRefs {
    final manager = $$EventItemsTableTableManager(
      $_db,
      $_db.eventItems,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaskItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskItemsTable> {
  $$TaskItemsTableFilterComposer({
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

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get requiredTime => $composableBuilder(
    column: $table.requiredTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> eventItemsRefs(
    Expression<bool> Function($$EventItemsTableFilterComposer f) f,
  ) {
    final $$EventItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventItems,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventItemsTableFilterComposer(
            $db: $db,
            $table: $db.eventItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskItemsTable> {
  $$TaskItemsTableOrderingComposer({
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

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get requiredTime => $composableBuilder(
    column: $table.requiredTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskItemsTable> {
  $$TaskItemsTableAnnotationComposer({
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

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<int> get requiredTime => $composableBuilder(
    column: $table.requiredTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  Expression<T> eventItemsRefs<T extends Object>(
    Expression<T> Function($$EventItemsTableAnnotationComposer a) f,
  ) {
    final $$EventItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventItems,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.eventItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskItemsTable,
          TaskItem,
          $$TaskItemsTableFilterComposer,
          $$TaskItemsTableOrderingComposer,
          $$TaskItemsTableAnnotationComposer,
          $$TaskItemsTableCreateCompanionBuilder,
          $$TaskItemsTableUpdateCompanionBuilder,
          (TaskItem, $$TaskItemsTableReferences),
          TaskItem,
          PrefetchHooks Function({bool eventItemsRefs})
        > {
  $$TaskItemsTableTableManager(_$AppDatabase db, $TaskItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TaskItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TaskItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$TaskItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<int> requiredTime = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> completed = const Value.absent(),
              }) => TaskItemsCompanion(
                id: id,
                title: title,
                subject: subject,
                requiredTime: requiredTime,
                dueDate: dueDate,
                priority: priority,
                completed: completed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String subject,
                required int requiredTime,
                Value<DateTime?> dueDate = const Value.absent(),
                required int priority,
                required bool completed,
              }) => TaskItemsCompanion.insert(
                id: id,
                title: title,
                subject: subject,
                requiredTime: requiredTime,
                dueDate: dueDate,
                priority: priority,
                completed: completed,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TaskItemsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({eventItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (eventItemsRefs) db.eventItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eventItemsRefs)
                    await $_getPrefetchedData<
                      TaskItem,
                      $TaskItemsTable,
                      EventItem
                    >(
                      currentTable: table,
                      referencedTable: $$TaskItemsTableReferences
                          ._eventItemsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TaskItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).eventItemsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.taskId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TaskItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskItemsTable,
      TaskItem,
      $$TaskItemsTableFilterComposer,
      $$TaskItemsTableOrderingComposer,
      $$TaskItemsTableAnnotationComposer,
      $$TaskItemsTableCreateCompanionBuilder,
      $$TaskItemsTableUpdateCompanionBuilder,
      (TaskItem, $$TaskItemsTableReferences),
      TaskItem,
      PrefetchHooks Function({bool eventItemsRefs})
    >;
typedef $$EventItemsTableCreateCompanionBuilder =
    EventItemsCompanion Function({
      Value<int> id,
      required String title,
      required String eventType,
      required DateTime startTime,
      required DateTime endTime,
      required String color,
      Value<int?> taskId,
    });
typedef $$EventItemsTableUpdateCompanionBuilder =
    EventItemsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> eventType,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<String> color,
      Value<int?> taskId,
    });

final class $$EventItemsTableReferences
    extends BaseReferences<_$AppDatabase, $EventItemsTable, EventItem> {
  $$EventItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TaskItemsTable _taskIdTable(_$AppDatabase db) => db.taskItems
      .createAlias($_aliasNameGenerator(db.eventItems.taskId, db.taskItems.id));

  $$TaskItemsTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<int>('task_id');
    if ($_column == null) return null;
    final manager = $$TaskItemsTableTableManager(
      $_db,
      $_db.taskItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

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

  $$TaskItemsTableFilterComposer get taskId {
    final $$TaskItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskItemsTableFilterComposer(
            $db: $db,
            $table: $db.taskItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  $$TaskItemsTableOrderingComposer get taskId {
    final $$TaskItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskItemsTableOrderingComposer(
            $db: $db,
            $table: $db.taskItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  $$TaskItemsTableAnnotationComposer get taskId {
    final $$TaskItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
          (EventItem, $$EventItemsTableReferences),
          EventItem,
          PrefetchHooks Function({bool taskId})
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
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<int?> taskId = const Value.absent(),
              }) => EventItemsCompanion(
                id: id,
                title: title,
                eventType: eventType,
                startTime: startTime,
                endTime: endTime,
                color: color,
                taskId: taskId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String eventType,
                required DateTime startTime,
                required DateTime endTime,
                required String color,
                Value<int?> taskId = const Value.absent(),
              }) => EventItemsCompanion.insert(
                id: id,
                title: title,
                eventType: eventType,
                startTime: startTime,
                endTime: endTime,
                color: color,
                taskId: taskId,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$EventItemsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (taskId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.taskId,
                            referencedTable: $$EventItemsTableReferences
                                ._taskIdTable(db),
                            referencedColumn:
                                $$EventItemsTableReferences._taskIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
      (EventItem, $$EventItemsTableReferences),
      EventItem,
      PrefetchHooks Function({bool taskId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TaskItemsTableTableManager get taskItems =>
      $$TaskItemsTableTableManager(_db, _db.taskItems);
  $$EventItemsTableTableManager get eventItems =>
      $$EventItemsTableTableManager(_db, _db.eventItems);
}
