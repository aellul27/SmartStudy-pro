import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import '../widgets/addevent.dart';
import '../widgets/removeevent.dart';

class Event {
  final String title;
  final DateTime start, end;
  final Color color;
  Event(this.title, this.start, this.end, this.color);
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
    _weekStart = now.subtract(Duration(days: now.weekday - 1));
    _startHour = _hourOptions.first;
    _endHour = _hourOptions.last;
  }

  void _shiftWeek(int days) =>
      setState(() => _weekStart = _weekStart.add(Duration(days: days)));

  Future<void> _addEvent(DateTime dt) async {
    final data = await AddEventDialog.show(context, dt);
    if (data != null) {
      setState(() {
        _events.add(Event(
          data.title,
          data.startTime,
          data.endTime,
          data.color,
        ));
      });
    }
  }

  void _removeEvent(Event ev) =>
      setState(() => _events.remove(ev));

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
    final totalHeight = cellHeight * visibleHours.length;

    return ScaffoldPage(
      header: PageHeader(
        leading: Row(children: [
          IconButton(icon: const Icon(FluentIcons.chevron_left), onPressed: () => _shiftWeek(-7)),
          IconButton(icon: const Icon(FluentIcons.chevron_right), onPressed: () => _shiftWeek(7)),
        ]),
        title: Text(
          '${DateFormat.yMd().format(days.first)} – ${DateFormat.yMd().format(days.last)}',
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
                    .map((e) => ComboBoxItem<String>(child: Text(e), value: e))
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
                    .map((e) => ComboBoxItem<String>(child: Text(e), value: e))
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
                        // … inside your Stack children, replacing the old Builder/Positioned for events …
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

                              // fractional start hour (e.g. 14.5 for 14:30)
                              final startFraction =
                                  (ev.start.hour + ev.start.minute / 60) - sIdx;
                              // duration in hours (e.g. 0.5 for 30 min)
                              final durationHours =
                                  ev.end.difference(ev.start).inMinutes / 60;

                              return Positioned(
                                // move right past the time‐column + 1px border
                                left: (dayIndex + 1) * cellWidth + 1,
                                // move down past the header‐row + 1px border
                                top: cellHeight + startFraction * cellHeight + 1,
                                width: cellWidth - 2,             // avoid vertical borders
                                height: durationHours * cellHeight - 2, // avoid horizontal borders
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: ev.color.withAlpha(100),
                                    border: Border.all(color: ev.color, width: 1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Stack(
                                    children: [
                                      Text(ev.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: const Icon(FluentIcons.delete, size: 12),
                                          onPressed: () async {
                                            final confirmed =
                                                await RemoveEventDialog.show(context, ev.title);
                                            if (confirmed == true) _removeEvent(ev);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
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