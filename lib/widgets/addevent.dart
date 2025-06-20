import 'package:fluent_ui/fluent_ui.dart';

class AddEventData {
  final String title;
  final String eventType;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;

  AddEventData(this.title, this.eventType, this.startTime, this.endTime, this.color);
}

class AddEventDialog {
  static Future<AddEventData?> show(BuildContext context, DateTime dt) async {
    final titleCtrl = TextEditingController();
    DateTime start = dt;
    DateTime end = dt.add(const Duration(hours: 1));

    Color selectedColor = Colors.blue;
    ColorSpectrumShape spectrumShape = ColorSpectrumShape.box;
    
    String? eventType = "Unavaliable";

    String? errorText;

    return showDialog<AddEventData>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, dialogSetState) => ContentDialog(
            title: const Text('Add event'),
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
                        value: "Unavaliable",
                        child: Text("Unavaliable"),
                      ),
                      ComboBoxItem<String>(
                        value: "Study time",
                        child: Text("Study time"),
                      ),
                    ],
                    onChanged: (c) => dialogSetState(() => eventType = c),
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
                        start = DateTime(dt.year, dt.month, dt.day, t.hour, t.minute);
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
                        end = DateTime(dt.year, dt.month, dt.day, t.hour, t.minute);
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
                child: const Text('Add'),
                onPressed: () {
                  final text = titleCtrl.text.trim();
                  if (text.isNotEmpty) {
                    Navigator.pop(ctx, AddEventData(text, eventType ?? "Unavaliable", start, end, selectedColor));
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