import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _weekStart;
  // key: DateTime at hour precision, value: list of titles
  final Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _weekStart = now.subtract(Duration(days: now.weekday - 1));
  }

  void _shiftWeek(int days) => setState(() => _weekStart = _weekStart.add(Duration(days: days)));

  Future<void> _addEvent(DateTime dt) async {
    String? title;
    await showDialog<void>(
      context: context,
      builder: (_) => ContentDialog(
        title: const Text('Add event'),
        content: TextBox(
          placeholder: 'Event title',
          onChanged: (v) => title = v,
        ),
        actions: [
          Button(child: const Text('Cancel'), onPressed: () => Navigator.pop(context)),
          FilledButton(
            child: const Text('Add'),
            onPressed: () {
              if ((title ?? '').trim().isNotEmpty) {
                setState(() {
                  _events.putIfAbsent(dt, () => []).add(title!.trim());
                });
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
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
    final hourLabels = List.generate(24, (h) => '${h.toString().padLeft(2, '0')}:00');
    final dateFmt = DateFormat('E\nMMM d');

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
      content: Expanded(
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
                          child: Text(dateFmt.format(d), textAlign: TextAlign.center),
                        ),
                    ],
                  ),
                  // hour rows
                  for (int h = 0; h < 24; h++)
                    TableRow(
                      children: [
                        // hour label
                        Container(
                          padding: const EdgeInsets.all(4),
                          color: Colors.grey,
                          child: Text(hourLabels[h]),
                        ),
                        // one cell per day
                        for (var d in days)
                          Button(
                            onPressed: () {
                              final dt = DateTime(d.year, d.month, d.day, h);
                              _addEvent(dt);
                            },
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 60),
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0;
                                      i < (_events[DateTime(d.year, d.month, d.day, h)]?.length ?? 0);
                                      i++)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _events[DateTime(d.year, d.month, d.day, h)]![i],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(FluentIcons.delete),
                                          onPressed: () => _removeEvent(
                                              DateTime(d.year, d.month, d.day, h), i),
                                        ),
                                      ],
                                    ),
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
    );
  }
}