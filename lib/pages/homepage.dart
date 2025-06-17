import 'package:fluent_ui/fluent_ui.dart';
import '../pieces/navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Row(
        children: [
           const Expanded(
            child:NavigationBar()
          )
        ],
      ),
    );
  }
}