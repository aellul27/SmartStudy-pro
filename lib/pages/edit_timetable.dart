import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import '../widgets/addevent.dart';
import '../widgets/removeevent.dart';
import '../widgets/updateevent.dart';
import '../database/add_events.dart';
import '../database/get_events.dart';
import '../database/remove_events.dart';
import '../database/update_events.dart';

class Event {
  // Include the DB id so we can remove/update
  final int id;
  final String title;
  final String eventType;
  final DateTime start, end;
  final Color color;
  Event(this.id, this.title, this.eventType, this.start, this.end, this.color);
}

class StudyCrossPainter extends CustomPainter {
final Color color;
const StudyCrossPainter({required this.color});

@override
void paint(Canvas canvas, Size size) {
  final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2;
    const step = 6.0;
    // ↘ lines
    for (double i = -size.height; i < size.width; i += step) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
    // ↙ lines
    for (double i = 0; i < size.width + size.height; i += step) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i - size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _weekStart;
  final List<String> _hourOptions =
      List.generate(24, (h) => '${h.toString().padLeft(2, '0')}:00');
  String? _startHour, _endHour;

  // ── now a flat list of Events ──
  final List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // ISO week starts Monday
    _weekStart = now.subtract(Duration(days: now.weekday - 1));
    _loadWeek();
    _startHour = _hourOptions.first;
    _endHour = _hourOptions.last;
  }

  Future<void> _loadWeek() async {
    final items = await getAllEventsWeek(weekSearch: _weekStart);
    setState(() {
      _events
        ..clear()
        ..addAll(items
          .where((e) => e.startTime != null && e.endTime != null)
          .map((e) => Event(
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

  Future<void> _removeEvent(Event ev) async {
    final confirmed = await RemoveEventDialog.show(context, ev.title);
    if (confirmed == true) {
      await removeEvent(id: ev.id);
      await _loadWeek();
    }
  }

  Future<void> _updateEvent(Event ev) async {
    final data = await UpdateEventDialog.show(
      context,
      UpdateEventData(ev.id, ev.title, ev.eventType, ev.start, ev.end, ev.color),
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
    final totalWidth = cellWidth * (days.length + 1);
    final totalHeight = (cellHeight + 2) * visibleHours.length;

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
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: totalWidth,
                    height: totalHeight,
                    child: Stack(
                      children: [
                        // 1) the grid underneath
                        Table(
                          defaultColumnWidth:
                              const FixedColumnWidth(cellWidth),
                          border: TableBorder.all(color: Colors.grey),
                          children: [
                            // header row
                            TableRow(children: [
                              Container(), // top-left
                              for (var d in days)
                                Button(
                                  onPressed: () {
                                    // schedule at the first visible hour
                                    final dt = DateTime(d.year, d.month, d.day, sIdx);
                                    _addEvent(dt);
                                  },
                                  style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                                    backgroundColor: WidgetStatePropertyAll(Colors.blue.lightest),
                                  ),
                                  child: SizedBox(
                                    height: cellHeight,
                                    child: Center(
                                      child: Text(
                                        DateFormat('E\nMMM d').format(d),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),  
                            ]),
                            // hour rows
                            for (var h in visibleHours)
                              TableRow(children: [
                                Container(
                                  height: cellHeight,
                                  color: Colors.grey,
                                  padding: const EdgeInsets.all(4),
                                  child:
                                      Text('${h.toString().padLeft(2, '0')}:00'),
                                ),
                                for (var d in days)
                                 Button(
                                   onPressed: () {
                                     final dt = DateTime(
                                         d.year, d.month, d.day, h);
                                     _addEvent(dt);
                                   },
                                   style: ButtonStyle(
                                     // remove padding so it fills the cell
                                     padding: WidgetStatePropertyAll(EdgeInsets.zero),
                                     // transparent background
                                     backgroundColor:
                                         WidgetStatePropertyAll(Colors.transparent),
                                   ),
                                   child: SizedBox(
                                     height: cellHeight,
                                   ),
                                 ),
                              ]),
                          ],
                        ),

                        // 2) overlay each event as a Positioned colored box
                        // … inside your for (var ev in _events) Positioned( … ) …
                        for (var ev in _events)
                          if (days.any((d) =>
                              d.year == ev.start.year &&
                              d.month == ev.start.month &&
                              d.day == ev.start.day))
                            Builder(builder: (_) {
                              final dayIndex = days.indexWhere((d) =>
                                  d.year == ev.start.year &&
                                  d.month == ev.start.month &&
                                  d.day == ev.start.day);

                              final startFraction =
                                  (ev.start.hour + ev.start.minute / 60) - sIdx;
                              final durationHours =
                                  ev.end.difference(ev.start).inMinutes / 60;

                              return Positioned(
                                // move right past the time‐column + 1px border
                                left: (dayIndex + 1) * cellWidth + 1,
                                // move down past the header‐row + 1px border
                                top: cellHeight + startFraction * (cellHeight + 2),
                                width: cellWidth - 2,             // avoid vertical borders
                                height: durationHours * cellHeight - 2, // avoid horizontal borders
                                child: GestureDetector(
                                  onTap: () => _updateEvent(ev),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: ev.color.withAlpha(100),
                                        border: Border.all(color: ev.color, width: 1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Stack(
                                        children: [
                                          if (ev.eventType == 'Study time')
                                            Positioned.fill(
                                              child: CustomPaint(
                                                painter: StudyCrossPainter(
                                                  color: ev.color.withAlpha(100), // you can bump alpha if needed
                                                ),
                                              ),
                                            ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    IconButton(
                                                    icon: const Icon(FluentIcons.delete, size: 12),
                                                    onPressed: () async {
                                                      await _removeEvent(ev);
                                                    },
                                                  ),  
                                                ],
                                               ),
                                             
                                              const SizedBox(height: 2),
                                              Text(ev.title,
                                                  overflow: TextOverflow.ellipsis),
                                            ],
                                         ),
                                        ]
                                      ),
                                    ),
                                  ),
                                )
                              );
                            }
                          ),
                      ],
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