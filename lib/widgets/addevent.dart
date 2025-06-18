import 'package:fluent_ui/fluent_ui.dart';

class AddEventData {
  final String title;
  final DateTime startTime;
  final DateTime endTime;

  AddEventData(this.title, this.startTime, this.endTime);
}

class AddEventDialog {
  static Future<AddEventData?> show(BuildContext context, DateTime dt) async {
    final titleCtrl = TextEditingController();
    DateTime start = dt;
    DateTime end = dt.add(const Duration(hours: 1));

    return showDialog<AddEventData>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, dialogSetState) => ContentDialog(
            title: const Text('Add event'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextBox(controller: titleCtrl),
                const SizedBox(height: 12),
                TimePicker(
                  header: 'Start',
                  selected: start,
                  onChanged: (t) {
                    dialogSetState(() {
                      start = DateTime(dt.year, dt.month, dt.day, t.hour, t.minute);
                      if (end.isBefore(start)) end = start.add(const Duration(hours: 1));
                    });
                  },
                ),
                const SizedBox(height: 8),
                TimePicker(
                  header: 'End',
                  selected: end,
                  onChanged: (t) {
                    dialogSetState(() {
                      end = DateTime(dt.year, dt.month, dt.day, t.hour, t.minute);
                      if (end.isBefore(start)) end = start.add(const Duration(hours: 1));
                    });
                  },
                ),
              ],
            ),
            actions: [
              Button(child: const Text('Cancel'), onPressed: () => Navigator.pop(ctx)),
              FilledButton(
                child: const Text('Add'),
                onPressed: () {
                  final text = titleCtrl.text.trim();
                  if (text.isNotEmpty) {
                    Navigator.pop(ctx, AddEventData(text, start, end));
                  } else {
                    Navigator.pop(ctx);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}