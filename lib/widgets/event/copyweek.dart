import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

class CopyWeekDialog {
  /// Pops up a dialog asking the user to confirm removal.
  /// Returns true if “Remove” was pressed, false if “Cancel” (or null if dismissed).
  static Future<bool?> show(BuildContext context, List days) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => ContentDialog(
        title: const Text('Paste Week?'),
        content: Text('Are you sure you want to remove every thing this week and replace it with events from\n“${DateFormat('d/M/y').format(days.first)} – ${DateFormat('d/M/y').format(days.last)}?'),
        actions: [
          Button(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          FilledButton(
            child: const Text('Copy'),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
  }
}