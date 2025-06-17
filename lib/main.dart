import 'package:fluent_ui/fluent_ui.dart';
import 'pages/homepage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'SmartStudy Pro',
      initialRoute: '/home',
      theme: FluentThemeData(
        brightness: Brightness.light,
        accentColor: Colors.blue,
      ),
      routes: {
        '/home': (_) => HomePage(),
      }
    );
  }
}
