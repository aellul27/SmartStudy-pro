import 'package:fluent_ui/fluent_ui.dart';
import '../pages/edit_timetable.dart';

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
            body: const Center(child: Text('Home page')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.edit),
            title: const Text('Edit Timetable'),
            body: const Center(child: CalendarPage()),
          ),
        ],
      ),
    );
  }
}