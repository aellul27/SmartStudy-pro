import 'package:fluent_ui/fluent_ui.dart';
var _orientation = 'landscape';
var _iconSize = 'medium_icons';

class TopBar extends StatelessWidget {
  const TopBar({super.key});
  @override
  Widget build(BuildContext context) {
    return MenuBar(
      items: [
        MenuBarItem(title: 'Add', items: []),
      ],
    );
  }
}