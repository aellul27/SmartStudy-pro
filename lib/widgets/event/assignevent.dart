import 'package:fluent_ui/fluent_ui.dart';
import '../../database/event_item.dart';
import '../../database/tasks/get_tasks.dart';

class AssignEventDialog {
  static Future<EventItem?> show(BuildContext context, EventItem event) async {
    int id = event.id;
    int? taskId = event.taskId;
    String? errorText;

    List taskList = await getAllTasksCompleted(completed: false);

    return showDialog<EventItem>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, dialogSetState) => ContentDialog(
            title: const Text('Assign event to task'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ComboBox(
                    value: taskId,
                    items: taskList.map<ComboBoxItem<int>>((task) {
                      return ComboBoxItem<int>(
                        value: task.id,
                        child: Text('${task.title} (${task.subject})'),
                      );
                    }).toList(),
                    onChanged: (c) => dialogSetState(() => taskId = c),
                  ),
                  if (errorText != null) ...[
                    const SizedBox(height: 4),
                    Text(errorText!, style: TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 12),
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
                  if (taskId != null) {
                    Navigator.pop(ctx, EventItem(id, event.title, event.eventType, event.startTime, event.endTime, event.color, taskId));
                  } else {
                    dialogSetState(() {
                      errorText = 'Please enter a task to select';
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