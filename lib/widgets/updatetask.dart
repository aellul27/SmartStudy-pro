import 'package:fluent_ui/fluent_ui.dart';

class UpdateTaskData {
  final String title;
  final String subject;
  final int requiredTime;
  final DateTime dueDate;
  final int priority;
  final bool completed;

  UpdateTaskData(this.title, this.subject, this.requiredTime, this.dueDate, this.priority, this.completed);
}

class UpdateaskDialog {
  static Future<UpdateTaskData?> show(BuildContext context, UpdateTaskData task) async {
    final titleCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    
    int requiredTime = task.requiredTime;
    DateTime dueDate = task.dueDate;
    int priority = task.priority;

    bool completed = task.completed;

    String? errorText;

    return showDialog<UpdateTaskData>(
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
                      // const Icon(
                      //   FluentIcons.status_triangle_exclamation,
                      //   size: 30,
                      // ),
                      Expanded(child: Slider (
                        label: priority.toString(),
                        value: priority.toDouble(),
                        min: 1.0,
                        max: 10.0,
                        divisions: 9,
                        onChanged: (v) => dialogSetState(() => priority = v.toInt()),
                      )),
                      // const Icon(
                      //   FluentIcons.bulleted_list,
                      //   size: 30,
                      // ),
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
                child: const Text('Update'),
                onPressed: () {
                  final title = titleCtrl.text.trim();
                  final subject = titleCtrl.text.trim();
                  if (title.isNotEmpty) {
                    Navigator.pop(ctx, UpdateTaskData(title, subject, requiredTime, dueDate, priority, completed));
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