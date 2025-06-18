import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import '../widgets/addevent.dart';
import '../widgets/removeevent.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _weekStart;

  // ── new state for hour‐range dropdowns ──
  final List<String> _hourOptions =
      List.generate(24, (h) => '${h.toString().padLeft(2, '0')}:00');
  String? _startHour;
  String? _endHour;

  // key: DateTime at hour precision, value: list of titles
  final Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _weekStart = now.subtract(Duration(days: now.weekday - 1));

    // ── init dropdowns ──
    _startHour = _hourOptions.first;
    _endHour = _hourOptions.last;
  }

  void _shiftWeek(int days) => setState(() => _weekStart = _weekStart.add(Duration(days: days)));

  Future<void> _addEvent(DateTime dt) async {
    final data = await AddEventDialog.show(context, dt);
    if (data != null) {
      final start = data.startTime;
      final end = data.endTime;
      final label = '${data.title} (${DateFormat.Hm().format(start)}–${DateFormat.Hm().format(end)})';
      setState(() {
        _events.putIfAbsent(start, () => []).add(label);
      });
    }
  }

  void _removeEvent(DateTime dt, int idx) {
    setState(() {
      _events[dt]?.removeAt(idx);
      if (_events[dt]?.isEmpty ?? false) _events.remove(dt);
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (i) => _weekStart.add(Duration(days: i)));

    // ── compute visible hours based on dropdowns ──
    final startIndex = _hourOptions.indexOf(_startHour!);
    final endIndex = _hourOptions.indexOf(_endHour!);
    final visibleHours =
        List.generate(endIndex - startIndex + 1, (i) => startIndex + i);

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
                  child: Table(
                    defaultColumnWidth: const FixedColumnWidth(100),
                    border: TableBorder.all(color: Colors.grey),
                    children: [
                      // header row
                      TableRow(
                        children: [
                          Container(), // top-left empty
                          for (var d in days)
                            Container(
                              padding: const EdgeInsets.all(4),
                              color: Colors.blue.lightest,
                              child: Text(
                                DateFormat('E\nMMM d').format(d),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                      // only loop over visible hours
                      for (var h in visibleHours)
                        TableRow(
                          children: [
                            // hour label
                            Container(
                              padding: const EdgeInsets.all(4),
                              color: Colors.grey,
                              child: Text('${h.toString().padLeft(2, '0')}:00'),
                            ),
                            // one cell per day
                            for (var d in days)
                              Button(
                                onPressed: () {
                                  final dt = DateTime(
                                      d.year, d.month, d.day, h);
                                  _addEvent(dt);
                                },
                                child: Container(
                                  constraints:
                                      const BoxConstraints(minHeight: 60),
                                  padding: const EdgeInsets.all(4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...() {
                                        final key = DateTime(
                                            d.year, d.month, d.day, h);
                                        return List.generate(
                                          _events[key]?.length ?? 0,
                                          (i) => Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  _events[key]![i],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    FluentIcons.delete),
                                                onPressed: () async {
                                                  final confirmed = await RemoveEventDialog.show(context, _events[key]![i]);
                                                  if (confirmed == true) {
                                                    _removeEvent(key, i);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }(),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
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