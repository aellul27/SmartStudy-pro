import 'package:fluent_ui/fluent_ui.dart';

class AssignTasksDialog {
  /// Pops up a dialog asking the user to confirm removal.
  /// Returns true if “Remove” was pressed, false if “Cancel” (or null if dismissed).
  static Future<double?> show(BuildContext context) {
    double dueDateWeight = 5.0;
    return showDialog<double>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, dialogSetState) => ContentDialog(
            title: const Text('Assign Tasks?'),
            content: IntrinsicHeight(
              child: Column(children: [
                Text('Are you sure you want to Assign Tasks?'),
                const SizedBox(height: 12),
                Text("Duedate weight compared to priority weight"),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("🚨"),
                    Expanded(
                      child: Slider(
                        label: dueDateWeight.toString(),
                        value: dueDateWeight.toDouble(),
                        min: 1.0,
                        max: 10.0,
                        divisions: 9,
                        onChanged: (v) =>
                            dialogSetState(() => dueDateWeight = v.toDouble()),
                      ),
                    ),
                    const Text("📆"),
                  ],
                ),
              ]),
            ),
            actions: [
              Button(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(ctx, null),
              ),
              FilledButton(
                child: const Text('Assign'),
                onPressed: () => Navigator.pop(ctx, dueDateWeight),
              ),
            ],
          ),
        );
      },
    );
  }
}