import 'package:fluent_ui/fluent_ui.dart';
import '../../database/task_item.dart';
import 'package:intl/intl.dart';
import '../../database/tasks/get_subjects.dart';

class UpdateTaskDialog {
  static Future<TaskItem?> show(BuildContext context, TaskItem task) async {
    final titleCtrl = TextEditingController(text: task.title);
    final subjectCtrl = TextEditingController(text: task.subject);
    
    int requiredTime = task.requiredTime;
    DateTime dueDate = task.dueDate;
    int priority = task.priority;

    bool completed = task.completed;

    String? errorText;
    final subjectlist = await getAllSubjects();

    return showDialog<TaskItem>(
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
                  AutoSuggestBox(
                    items: subjectlist.map((subject) {
                      return AutoSuggestBoxItem(
                        value: subject,
                        label: subject.toString(),
                      );
                    }).toList(),
                    controller: subjectCtrl,
                    placeholder: "Subject",
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
                          placeholderText: DateFormat.yMd('en_au').format(dueDate),
                          onSelectionChanged: (value) {
                            dialogSetState(() {
                              dueDate = value.selectedDates[0];
                            });
                          },
                          isOutOfScopeEnabled: false,
                          isGroupLabelVisible: false,
                          locale: const Locale('en_au'),
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
                    ]),
                  const SizedBox(height: 12),
                  ToggleSwitch(
                    checked: completed,
                    onChanged: (s) => dialogSetState(() => completed = s),
                  )
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
                  String subject = subjectCtrl.text.trim();
                  subject = '${subject[0].toUpperCase()}${subject.substring(1)}';
                  if (title.isNotEmpty && subject.isNotEmpty && subject != "All") {
                    Navigator.pop(ctx, TaskItem(task.id, title, subject, requiredTime, dueDate, priority, completed));
                  } else {
                    dialogSetState(() {
                      errorText = 'Please enter a title, subject, and a valid due date. Subject cannot be "All".';
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