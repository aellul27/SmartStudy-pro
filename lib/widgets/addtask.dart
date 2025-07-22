import 'package:fluent_ui/fluent_ui.dart';

class AddTaskData {
  final String title;
  final String subject;
  final int requiredTime;
  final DateTime dueDate;
  final int priority;
  final bool completed;

  AddTaskData(this.title, this.subject, this.requiredTime, this.dueDate, this.priority, this.completed);
}

class AddTaskDialog {
  static Future<AddTaskData?> show(BuildContext context) async {
    final titleCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    
    int requiredTime = 30;
    DateTime dueDate = DateTime.now().add(const Duration(days: 1));
    int priority = 5;

    bool completed = false;

    String? errorText;

    return showDialog<AddTaskData>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, dialogSetState) => ContentDialog(
            title: const Text('Add Task'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Title"), const SizedBox(height: 4),
                  TextBox(
                    controller: titleCtrl,
                    placeholder: 'Title',
                  ),
                  if (errorText != null) ...[
                    const SizedBox(height: 4),
                    Text(errorText!, style: TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 12),
                  Text("Subject"), const SizedBox(height: 4 ),
                  TextBox(
                    controller: subjectCtrl,
                    placeholder: 'Subject',
                  ),
                  const SizedBox(height: 12),
                  Text("Required Time (minutes)"), const SizedBox(height: 4),
                  NumberFormBox(
                    value: requiredTime,
                    onChanged: (c) => dialogSetState(() => requiredTime = c!),
                    mode: SpinButtonPlacementMode.inline,
                    min: 0,
                  ),
                  const SizedBox(height: 12),
                  IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, bottom: 4.0),
                          child: Text("Due Date"),
                        ),
                        CalendarDatePicker(
                          onSelectionChanged: (value) {
                            debugPrint('${value.selectedDates}');
                          },
                          isOutOfScopeEnabled: false,
                          isGroupLabelVisible: false,
                          locale: const Locale('en'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text("Priority"), const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("🚨"),
                      Expanded(child: Slider (
                        label: priority.toString(),
                        value: priority.toDouble(),
                        min: 1.0,
                        max: 10.0,
                        divisions: 9,
                        onChanged: (v) => dialogSetState(() => priority = v.toInt()),
                      )),
                      const Text("😴"),
                    ]
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
                  final title = titleCtrl.text.trim();
                  final subject = titleCtrl.text.trim();
                  if (title.isNotEmpty) {
                    Navigator.pop(ctx, AddTaskData(title, subject, requiredTime, dueDate, priority, completed));
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