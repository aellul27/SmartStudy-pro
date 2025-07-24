import 'package:fluent_ui/fluent_ui.dart';
import 'package:smartstudy_pro/database/tasks/add_tasks.dart';
import 'package:smartstudy_pro/database/tasks/get_tasks.dart';
import 'package:smartstudy_pro/widgets/tasks/addtask.dart';
import '../database/task_item.dart';

class EditTasksPage extends StatefulWidget {
  const EditTasksPage({super.key});
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTasksPage> {
  final List<TaskItem> _tasks = [];
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }


  Future<void> _loadTasks() async {
    final items = await getAllTasksCompleted(completed: false);
    setState(() {
      _tasks
        ..clear()
        ..addAll(items
          .where((e) => e.dueDate != null)
          .map((e) => TaskItem(
            e.id,
            e.title,
            e.subject,
            e.requiredTime,
            e.dueDate!,
            e.priority,
            e.completed,
          ))
        )
      ;
    });
  }

  Future<void> _addTask() async {
    final data = await AddTaskDialog.show(context);
    if (data != null) {
      await addTask(
        title: data.title,
        subject: data.subject,
        requiredTime: data.requiredTime,
        dueDate: data.dueDate,
        priority: data.priority,
        completed: data.completed,
      );
      await _loadTasks();
    }
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        leading: Row(children: [
          IconButton(icon: const Icon(FluentIcons.add), onPressed: _addTask),
          IconButton(icon: const Icon(FluentIcons.search), onPressed: null),
        ]),
        title: Text(
          'Edit Tasks',
        ),
      ),
      content: const Center(child: Text('No content yet.')),
    );
  }
}

