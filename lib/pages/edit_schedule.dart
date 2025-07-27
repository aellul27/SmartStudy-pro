import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:smartstudy_pro/widgets/tasks/assigntasks.dart';
import '../database/events/get_events.dart';
import '../database/events/update_events.dart';
import '../database/event_item.dart';
import '../database/task_item.dart';
import '../database/tasks/get_tasks.dart';
import '../widgets/event/assignevent.dart';
import '../widgets/timetable_viewer.dart';
import '../widgets/event/removeassign.dart';
import '../pieces/auto_assign.dart';

class EditSchedulePage extends StatefulWidget {
  const EditSchedulePage({super.key});
  @override
  _EditScheduleState createState() => _EditScheduleState();
}

class _EditScheduleState extends State<EditSchedulePage> {
  late final ScrollController _horizontalController;
  late final ScrollController _verticalController;
  late DateTime _weekStart;
  final List<String> _hourOptions =
      List.generate(24, (h) => '${h.toString().padLeft(2, '0')}:00');
  String? _startHour, _endHour;

  // ── now a flat list of Events ──
  final List<EventItem> _events = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // ISO week starts Monday
    _weekStart = now.subtract(Duration(days: now.weekday - 1));
    _loadWeek();
    _startHour = _hourOptions.first;
    _endHour = _hourOptions.last;
    _horizontalController = ScrollController();
    _verticalController = ScrollController();
  }
  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  Future<void> _loadWeek() async {
    final items = await getAllEventsWeek(weekSearch: _weekStart);

    // Fetch all TaskItems for events with a taskId
    final Map<int, TaskItem> taskItems = {};
    final eventsWithTaskId = items.where((e) => e.taskId != null).toList();
    for (final e in eventsWithTaskId) {
      // You may need to replace this with your actual method to fetch a TaskItem by ID
      final task = await getTaskWithId(idToGet: e.taskId!);
      if (task != null) {
        taskItems[e.taskId!] = TaskItem(
          task.id,
          task.title,
          task.subject,
          task.requiredTime,
          task.dueDate!,
          task.priority,
          task.completed,
        );
      }
    }

    if (!mounted) return;
    setState(() {
      _events
        ..clear()
        ..addAll(items
          .map((e) => EventItem(
                e.id,
                e.title,
                e.eventType,
                e.startTime,
                e.endTime,
                _parseColor(e.color),
                e.taskId,
                taskItem: e.taskId != null ? taskItems[e.taskId!] : null,
              )));
    });
  }

  // hex "#RRGGBB" or "#AARRGGBB"
  Color _parseColor(String hex) {
    var h = hex.replaceFirst('#', '');
    if (h.length == 6) h = 'FF$h';
    return Color(int.parse(h, radix: 16));
  }

  void _shiftWeek(int days) async {
    setState(() => _weekStart = _weekStart.add(Duration(days: days)));
    await _loadWeek();
  }

  Future<void> _assignEvent(EventItem ev) async {
    final data = await AssignEventDialog.show(context, ev);
    if (data != null) {
      await updateEvent(
        id: data.id,
        title: data.title,
        eventType: data.eventType,
        startTime: data.startTime,
        endTime: data.endTime,
        color: '#${data.color.toARGB32().toRadixString(16).padLeft(8, '0')}',
        taskId: data.taskId,
      );
      await _loadWeek();
    }
  }

  Future<void> _removeAssign(EventItem ev) async {
    final confirmed = await RemoveAssignDialog.show(context, ev.title);
    if (confirmed == true) {
      await updateEvent(
        id: ev.id,
        title: ev.title,
        eventType: ev.eventType,
        startTime: ev.startTime,
        endTime: ev.endTime,
        color: '#${ev.color.toARGB32().toRadixString(16).padLeft(8, '0')}',
        taskId: null,
      );
      await _loadWeek();
    }
  }

  Future<void> _removeAllAssigns() async {
    final confirmed = await RemoveAssignDialog.show(context, "All Assigns This Week");
    if (confirmed == true) {
      for (var ev in _events) {
        await updateEvent(
        id: ev.id,
        title: ev.title,
        eventType: ev.eventType,
        startTime: ev.startTime,
        endTime: ev.endTime,
        color: '#${ev.color.toARGB32().toRadixString(16).padLeft(8, '0')}',
        taskId: null,
      );
      }
      await _loadWeek();
    }
  }


  Future<void> _autoAssign() async {
    final double? ratio = await AssignTasksDialog.show(context);
    if (ratio != null) {
      try {
        await autoAssignStudyTime(_weekStart, ratio);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (context) => ContentDialog(
        title: const Text('Auto-Assign Failed'),
        content: Text(e.toString()),
        actions: [
          Button(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
          ),
        );
      }
      await _loadWeek();
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (i) => _weekStart.add(Duration(days: i)));

    final sIdx = _hourOptions.indexOf(_startHour!);
    final eIdx = _hourOptions.indexOf(_endHour!);
    final visibleHours = List.generate(eIdx - sIdx + 1, (i) => sIdx + i);

    // cell sizing
    const cellWidth = 100.0;
    const cellHeight = 60.0;


    return ScaffoldPage(
      header: PageHeader(
        leading: Row(children: [
          IconButton(icon: const Icon(FluentIcons.chevron_left), onPressed: () => _shiftWeek(-7)),
          IconButton(icon: const Icon(FluentIcons.chevron_right), onPressed: () => _shiftWeek(7)),
          IconButton(
            icon: const Icon(FluentIcons.lightning_bolt),
            onPressed: _autoAssign,
          ),
          IconButton(icon: const Icon(FluentIcons.calculator_multiply), onPressed: () => _removeAllAssigns()),
        ]),
        title: Column(
          children: [
            Text('Schedule editor'),
            Text(
              '${DateFormat('d/M/y').format(days.first)} – ${DateFormat('d/M/y').format(days.last)}',
              textScaler: TextScaler.linear(0.5),
            ),
          ],
        )
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── two dropdowns for start/end hour ──
          Row(
            children: [
              ComboBox<String>(
                value: _startHour,
                items: _hourOptions
                    .map((e) => ComboBoxItem<String>(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() {
                  _startHour = v!;
                  // if end ≤ new start, bump end to the very next hour
                  final sIdx = _hourOptions.indexOf(_startHour!);
                  final eIdx = _hourOptions.indexOf(_endHour!);
                  if (eIdx <= sIdx && sIdx + 1 < _hourOptions.length) {
                    _endHour = _hourOptions[sIdx + 1];
                  }
                }),
                placeholder: const Text('Start'),
              ),
              const SizedBox(width: 16),
              ComboBox<String>(
                value: _endHour,
                items: _hourOptions
                    .where((e) =>
                        _hourOptions.indexOf(e) >
                        _hourOptions.indexOf(_startHour!))
                    .map((e) => ComboBoxItem<String>(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _endHour = v),
                placeholder: const Text('End'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // ── the scrollable table ──
          Expanded(
            child: Scrollbar(
              controller: _horizontalController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _horizontalController,
                scrollDirection: Axis.horizontal,
                child: Scrollbar(
                  controller: _verticalController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _verticalController,
                    scrollDirection: Axis.vertical,
                    child: TimetableViewer(
                      days: days,
                      visibleHours: visibleHours,
                      events: _events,
                      showTasks: true,
                      cellWidth: cellWidth,
                      cellHeight: cellHeight,
                      editable: true,
                      onEventTap: (ev) => _assignEvent(ev),
                      onEventDelete: (ev) => _removeAssign(ev),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}