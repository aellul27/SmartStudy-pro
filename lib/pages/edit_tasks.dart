import 'package:fluent_ui/fluent_ui.dart';
import 'package:smartstudy_pro/database/tasks/add_tasks.dart';
import 'package:smartstudy_pro/database/tasks/get_tasks.dart';
import 'package:smartstudy_pro/database/tasks/get_subjects.dart';
import 'package:smartstudy_pro/database/tasks/update_tasks.dart';
import 'package:smartstudy_pro/widgets/tasks/addtask.dart';
import 'package:smartstudy_pro/widgets/tasks/updatetask.dart';
import '../database/task_item.dart';
import 'package:intl/intl.dart';

class EditTasksPage extends StatefulWidget {
  const EditTasksPage({super.key});
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTasksPage> {
  final List<TaskItem> _tasks = [];
  List _subjects = [];
  String _selectedsubject = "All";
  bool toGetCompleted = false;
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }


  Future<void> _loadTasks() async {
    List items = await getAllTasksCompleted(completed: toGetCompleted);
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
    items = await getAllSubjects();
    if (!mounted) return;
    setState(() {
      _subjects = ['All', ...items];
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
  Future<void> _updateTask(taskToUpdate) async {
    final data = await UpdateTaskDialog.show(context, taskToUpdate);
    if (data != null) {
      await updateTask(
        id: data.id,
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
        ]),
        title: Text(
          'Edit Tasks',
        ),
      ),
      content: Column(
        children: [
          Row(
            children: [
              ComboBox<String>(
                value: _selectedsubject,
                items: _subjects.map<ComboBoxItem<String>>((e) {
                  return ComboBoxItem<String>(
                    child: Text(e),
                    value: e,
                  );
                }).toList(),
                onChanged: (subject) {
                  setState(() => _selectedsubject = subject!);
                },
              ),
              ToggleSwitch(
                checked: toGetCompleted,
                onChanged: (v) async {
                  setState(() => toGetCompleted = v);
                  await _loadTasks();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Text("Completed"),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final filteredTasks = _selectedsubject == "All"
                  ? _tasks
                  : _tasks.where((t) => t.subject == _selectedsubject).toList();
                if (index >= filteredTasks.length) return const SizedBox.shrink();
                final taskiter = filteredTasks[index];
                Color getPriorityColor(int priority) {
                  // Clamp priority between 1 and 10
                  final p = priority.clamp(1, 10);
                  // Interpolate from red (1) to blue (10)
                  return Color.lerp(Colors.red, Colors.blue, (p - 1) / 9)!;
                }
                return ListTile.selectable(
                  title: Text(taskiter.title),
                  subtitle: Text('${taskiter.subject} - ${DateFormat.yMd('en_au').format(taskiter.dueDate)} - ${taskiter.requiredTime} minutes'),
                  tileColor: WidgetStateProperty.all(getPriorityColor(taskiter.priority)),
                  selectionMode: ListTileSelectionMode.single,
                  onSelectionChange: (selected) async {
                    if (selected) {
                      await _updateTask(taskiter);
                      selected = false;
                    }
                  },
                  trailing: Icon(FluentIcons.delete),
                );
              }
            ),
          ),
        ],
      )
    );
  }
}

