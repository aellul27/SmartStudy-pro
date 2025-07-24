import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:smartstudy_pro/widgets/event/removeevent.dart';
import '../widgets/event/addevent.dart';
import '../widgets/event/updateevent.dart';
import '../database/events/add_events.dart';
import '../database/events/get_events.dart';
import '../database/events/update_events.dart';
import '../database/events/remove_events.dart';
import '../database/event_item.dart';
import '../widgets/timetable_viewer.dart';

class EditTimetablePage extends StatefulWidget {
  const EditTimetablePage({super.key});
  @override
  _EditTimetableState createState() => _EditTimetableState();
}

class _EditTimetableState extends State<EditTimetablePage> {
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
    if (!mounted) return;
    setState(() {
      _events
        ..clear()
        ..addAll(items
          .where((e) => e.startTime != null && e.endTime != null)
          .map((e) => EventItem(
            e.id,
            e.title,
            e.eventType,
            e.startTime!,
            e.endTime!,
            _parseColor(e.color),
          ))
        )
      ;
    });
  }

  // hex "#RRGGBB" or "#AARRGGBB"
  Color _parseColor(String hex) {
    var h = hex.replaceFirst('#', '');
    if (h.length == 6) h = 'FF$h';
    return Color(int.parse(h, radix: 16));
  }

  void _shiftWeek(int days) =>
      setState(() => _weekStart = _weekStart.add(Duration(days: days)));

  Future<void> _addEvent(DateTime dt) async {
    final data = await AddEventDialog.show(context, dt);
    if (data != null) {
      await addEvent(
        title: data.title,
        eventType: data.eventType,
        startTime: data.startTime,
        endTime: data.endTime,
        color: '#${data.color.toARGB32().toRadixString(16).padLeft(8, '0')}',
      );
      await _loadWeek();
    }
  }

  Future<void> _removeEvent(EventItem ev) async {
    final confirmed = await RemoveEventDialog.show(context, ev.title);
    if (confirmed == true) {
      await removeEvent(id: ev.id);
      await _loadWeek();
    }
  }

  Future<void> _updateEvent(EventItem ev) async {
    final data = await UpdateEventDialog.show(
      context,
      EventItem(ev.id, ev.title, ev.eventType, ev.startTime, ev.endTime, ev.color),
    );
    if (data != null) {
      await updateEvent(
        id: data.id,
        title: data.title,
        eventType: data.eventType,
        startTime: data.startTime,
        endTime: data.endTime,
        color: '#${data.color.toARGB32().toRadixString(16).padLeft(8, '0')}',
      );
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
          IconButton(icon: const Icon(FluentIcons.calculator_multiply), onPressed: () => DoNothingAction),
        ]),
        title: Text(
          '${DateFormat('d/M/y').format(days.first)} – ${DateFormat('d/M/y').format(days.last)}',
        ),
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
                      cellWidth: cellWidth,
                      cellHeight: cellHeight,
                      editable: true,
                      onCellTap: (dt) => _addEvent(dt),
                      onEventTap: (ev) => _updateEvent(ev),
                      onEventDelete: (ev) => _removeEvent(ev),
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