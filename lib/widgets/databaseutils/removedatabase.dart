import 'package:fluent_ui/fluent_ui.dart';
import '../../database/utils/database_utils_export.dart';

class RemoveDatabaseDialog {
  /// Pops up a dialog asking the user to confirm removal.
  /// Returns true if “Remove” was pressed, false if “Cancel” (or null if dismissed).
  static Future<bool?> show(BuildContext context) async {
    final proceed = await showDialog<bool>(
      context: context,
      builder: (ctx) => ContentDialog(
        title: const Text('Remove database?'),
        content: Text('Are you sure you want to remove the database? This is unrecoverable.'),
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
    if (proceed == true) {
      return await showWithConfirmation(context);
    }
    return proceed;
  }

  /// Dialog that requires the user to type 'Yes I understand.' before enabling Remove.
  static Future<bool?> showWithConfirmation(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) => ContentDialog(
            title: const Text('Remove database?'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('This action is unrecoverable. To confirm, type:'),
                const SizedBox(height: 8),
                const Text('Yes I understand.', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextBox(
                  controller: controller,
                  placeholder: 'Type here to confirm',
                  onChanged: (_) => setState(() {}),
                  autofocus: true,
                ),
              ],
            ),
            actions: [
              Button(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(ctx, false),
              ),
              FilledButton(
                onPressed: controller.text == 'Yes I understand.'
                    ? () => {
                      dropAllTables(),
                      Navigator.pop(ctx, true),
                    }
                    : null,
                child: const Text('Remove'),
              ),
            ],
          ),
        );
      },
    );
    
  }
}