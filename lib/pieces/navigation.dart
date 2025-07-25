import 'package:fluent_ui/fluent_ui.dart';
import '../pages/dashboard.dart';
import '../pages/edit_timetable.dart';
import '../pages/edit_tasks.dart';
import '../pages/edit_schedule.dart';
import '../database/utils/database_utils_export.dart';
import '../widgets/databaseutils/removedatabase.dart';
import '../widgets/databaseutils/importdatabase.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ratio = size.width / size.height;
    final mode = ratio < 0.75
        ? PaneDisplayMode.compact
        : PaneDisplayMode.open;

    return NavigationView(
      pane: NavigationPane(
        displayMode: mode,
        selected: selected,
        onChanged: (i) => setState(() => selected = i),
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text('Home'),
            body: const Center(child: DashboardPage()),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.edit),
            title: const Text('Edit Schedule'),
            body: const Center(child: EditSchedulePage()),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.edit),
            title: const Text('Edit Timetable'),
            body: const Center(child: EditTimetablePage()),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.edit),
            title: const Text('Edit Tasks'),
            body: const Center(child: EditTasksPage()),
          ),
          PaneItemAction(
            icon: const WindowsIcon(WindowsIcons.save),
            title: const Text('Save file'),
            onTap: () {
              dumpDatabaseWithSaveFile();
            },
          ),
          PaneItemAction(
            icon: const WindowsIcon(WindowsIcons.upload),
            title: const Text('Load file'),
            onTap: () async {
              await ImportDatabaseDialog.show(context);
              setState(() => selected = 0); // Go back to Home page
            },
          ),
          PaneItemAction(
            icon: const WindowsIcon(WindowsIcons.delete),
            title: const Text('Delete database'),
            onTap: () async {
              await RemoveDatabaseDialog.show(context);
              setState(() => selected = 0); // Go back to Home page
            },
          ),
        ],
      ),
    );
  }
}