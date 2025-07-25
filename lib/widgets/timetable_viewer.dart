import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import '../database/event_item.dart';
import 'study_cross_painter.dart';

class TimetableViewer extends StatelessWidget {
  final List<DateTime> days;
  final List<int> visibleHours;
  final List<EventItem> events;
  final double cellWidth;
  final double cellHeight;
  final bool editable;
  final void Function(DateTime)? onCellTap;
  final void Function(EventItem)? onEventTap;
  final Future<void> Function(EventItem)? onEventDelete; // Added onEventDelete property

  const TimetableViewer({
    super.key,
    required this.days,
    required this.visibleHours,
    required this.events,
    this.cellWidth = 100.0,
    this.cellHeight = 60.0,
    required this.editable,
    this.onCellTap,
    this.onEventTap,
    this.onEventDelete, // Initialize onEventDelete in the constructor
  });

  @override
  Widget build(BuildContext context) {
    final totalWidth = cellWidth * (days.length + 1);
    final totalHeight = (cellHeight + 2) * visibleHours.length;
    final eventDelete = onEventDelete;
    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Stack(
        children: [
          // 1) the grid underneath
          Table(
            defaultColumnWidth: FixedColumnWidth(cellWidth),
            border: TableBorder.all(color: Colors.grey),
            children: [
              // header row
              TableRow(children: [
                Container(), // top-left
                for (var d in days)
                  Button(
                    onPressed: onCellTap != null
                        ? () => onCellTap!(DateTime(d.year, d.month, d.day, visibleHours.first))
                        : null,
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
                    child: Text('${h.toString().padLeft(2, '0')}:00'),
                  ),
                  for (var d in days)
                    Button(
                      onPressed: onCellTap != null
                          ? () => onCellTap!(DateTime(d.year, d.month, d.day, h))
                          : null,
                      style: ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                      ),
                      child: SizedBox(
                        height: cellHeight,
                      ),
                    ),
                ]),
            ],
          ),
          // 2) overlay each event as a Positioned colored box
          for (var ev in events)
            if (days.any((d) =>
                d.year == ev.startTime.year &&
                d.month == ev.startTime.month &&
                d.day == ev.startTime.day))
              Builder(builder: (_) {
                final dayIndex = days.indexWhere((d) =>
                    d.year == ev.startTime.year &&
                    d.month == ev.startTime.month &&
                    d.day == ev.startTime.day);
                final sIdx = visibleHours.first;
                final startFraction =
                    (ev.startTime.hour + ev.startTime.minute / 60) - sIdx;
                final durationHours =
                    ev.endTime.difference(ev.startTime).inMinutes / 60;
                final headerBottom = cellHeight + 1;
                final slotHeight = cellHeight + 2;
                final rawTop = cellHeight + startFraction * slotHeight;
                final rawBottom = rawTop + durationHours * slotHeight - 2;
                if (rawBottom <= headerBottom) return const SizedBox.shrink();
                final top = rawTop < headerBottom ? headerBottom : rawTop;
                final bottomLimit = headerBottom + visibleHours.length * slotHeight - 2;
                final bottom = rawBottom > bottomLimit ? bottomLimit : rawBottom;
                final height = bottom - top;
                // eventDelete is captured from the outer scope
                return Positioned(
                  left: (dayIndex + 1) * cellWidth + 1,
                  top: top,
                  width: cellWidth - 2,
                  height: height,
                  child: GestureDetector(
                    onTap: onEventTap != null ? () => onEventTap!(ev) : null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: ev.color.withAlpha(100),
                              border: Border.all(color: ev.color, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          if (ev.eventType == 'Study time')
                            IgnorePointer(
                              child: CustomPaint(
                                painter: StudyCrossPainter(color: ev.color.withAlpha(120)),
                              ),
                            ),
                          // Draw text and trashcan on top of everything
                          Container(
                            padding: const EdgeInsets.all(4),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(ev.title, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          if (editable == true)
                            Align(
                              alignment: Alignment.bottomRight,
                              child: 
                                IconButton(
                                  icon: const Icon(FluentIcons.delete, size: 12),
                                  onPressed: eventDelete != null
                                      ? () async { await eventDelete(ev); }
                                      : null,
                                  style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(EdgeInsets.only(right: 8.0, bottom: 8.0)),
                                    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                                  ),
                                )
                              )
                          ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
