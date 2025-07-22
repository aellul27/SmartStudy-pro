import 'package:fluent_ui/fluent_ui.dart';
import '../database/event_item.dart';

class UpdateEventDialog {
  static Future<EventItem?> show(BuildContext context, EventItem event) async {
    int id = event.id;
    final titleCtrl = TextEditingController(text: event.title);
    DateTime start = event.startTime;
    DateTime end = event.endTime;
    Color selectedColor = event.color;
    ColorSpectrumShape spectrumShape = ColorSpectrumShape.box;
    String eventType = event.eventType;
    String? errorText;

    return showDialog<EventItem>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, dialogSetState) => ContentDialog(
            title: const Text('Edit event'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextBox(
                    controller: titleCtrl,
                    placeholder: 'Title',
                  ),
                  if (errorText != null) ...[
                    const SizedBox(height: 4),
                    Text(errorText!, style: TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 12),
                  ComboBox(
                    value: eventType,
                    items: [
                      ComboBoxItem<String>(
                        value: "Unavailable",
                        child: Text("Unavailable"),
                      ),
                      ComboBoxItem<String>(
                        value: "Study time",
                        child: Text("Study time"),
                      ),
                    ],
                    onChanged: (c) => dialogSetState(() => eventType = c ?? "Unavailable"),
                  ),
                  const SizedBox(height: 12),
                  ColorPicker(
                    color: selectedColor,
                    onChanged: (c) => dialogSetState(() => selectedColor = c),
                    colorSpectrumShape: spectrumShape,
                    isMoreButtonVisible: true,
                    isColorSliderVisible: true,
                    isColorChannelTextInputVisible: true,
                    isHexInputVisible: true,
                    isAlphaEnabled: false,
                  ),
                  const SizedBox(height: 12),
                  TimePicker(
                    header: 'Start',
                    selected: start,
                    onChanged: (t) {
                      dialogSetState(() {
                        start = DateTime(start.year, start.month, start.day, t.hour, t.minute);
                        if (end.isBefore(start)) end = start.add(const Duration(hours: 1));
                      });
                    },
                    hourFormat: HourFormat.HH,
                  ),
                  const SizedBox(height: 8),
                  TimePicker(
                    header: 'End',
                    selected: end,
                    onChanged: (t) {
                      dialogSetState(() {
                        end = DateTime(end.year, end.month, end.day, t.hour, t.minute);
                        if (end.isBefore(start)) end = start.add(const Duration(hours: 1));
                      });
                    },
                    hourFormat: HourFormat.HH,
                  ),
                ],
              ),
            ),
            actions: [
              Button(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(ctx),
              ),
              FilledButton(
                child: const Text('Update'),
                onPressed: () {
                  final text = titleCtrl.text.trim();
                  if (text.isNotEmpty) {
                    Navigator.pop(ctx, EventItem(id, text, eventType, start, end, selectedColor));
                  } else {
                    dialogSetState(() {
                      errorText = 'Please enter a title';
                    });
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