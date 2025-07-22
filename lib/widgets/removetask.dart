import 'package:fluent_ui/fluent_ui.dart';

class RemoveEventDialog {
  /// Pops up a dialog asking the user to confirm removal.
  /// Returns true if “Remove” was pressed, false if “Cancel” (or null if dismissed).
  static Future<bool?> show(BuildContext context, String taskLabel) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => ContentDialog(
        title: const Text('Remove Task?'),
        content: Text('Are you sure you want to remove\n“$taskLabel?'),
        actions: [
          Button(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          FilledButton(
            child: const Text('Remove'),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
  }
}