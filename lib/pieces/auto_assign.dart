import '../database/database.dart';
import '../database/events/get_events.dart';
import '../database/events/update_events.dart';
import '../database/tasks/get_tasks.dart';
import '../database/events/add_events.dart';

/// Adjust this to balance due date vs priority (1 = only priority, 10 = only due date)
double dueDateWeight = 5.0; // 1-10, can be set from UI

/// Automatically assigns study_time events to tasks based on priority and due date.
/// Splits events if needed to fit required time and due dates.
/// Call this function and then reload your week/events.
Future<void> autoAssignStudyTime(DateTime weekStart) async {
  // Get all events from today onwards (not just the week)
  final now = DateTime.now();
  final events = await getAllEvents();
  final tasks = await getAllTasksCompleted(completed: false);

  final studyEvents = events
      .where((e) => e.eventType == 'Study time' && !e.startTime.isBefore(now))
      .toList();
  final tasksNeedingStudy = tasks.where((t) => !t.completed && t.requiredTime > 0).toList();

  List<_TaskScore> scoredTasks = tasksNeedingStudy.map((t) {
    double priorityScore = (10 - t.priority).toDouble();
    double dueInDays = t.dueDate!.difference(now).inDays.toDouble().clamp(0, 365);
    double dueScore = (365 - dueInDays) / 365 * 10;
    double score = (priorityScore * (11 - dueDateWeight) + dueScore * dueDateWeight) / 10;
    return _TaskScore(task: t, score: score);
  }).toList();

  scoredTasks.sort((a, b) => b.score.compareTo(a.score));
  Map<int, double> assignedTime = { for (var t in scoredTasks) t.task.id : 0.0 };

  // Add already assigned event minutes to assignedTime before assigning new events
  for (var event in studyEvents) {
    if (event.taskId != null && assignedTime.containsKey(event.taskId)) {
      double eventMinutes = event.endTime.difference(event.startTime).inMinutes.toDouble();
      if (eventMinutes > 0) {
        assignedTime[event.taskId!] = assignedTime[event.taskId!]! + eventMinutes;
      }
      studyEvents.remove(event);
    }
  }
  // Calculate total required study minutes and available study event minutes
  double totalRequiredMinutes = scoredTasks.fold(
    0.0, (sum, t) => sum + (t.task.requiredTime - assignedTime[t.task.id]!).clamp(0, double.infinity));
  double totalAvailableMinutes = studyEvents.fold(
    0.0, (sum, e) => sum + e.endTime.difference(e.startTime).inMinutes.toDouble());

  if (totalAvailableMinutes < totalRequiredMinutes) {
    throw Exception(
      'Not enough study time available to assign all tasks. '
      'Required: ${totalRequiredMinutes.round()} min, '
      'Available: ${totalAvailableMinutes.round()} min');
  }
  
  for (var event in studyEvents) {

    double eventMinutes = event.endTime.difference(event.startTime).inMinutes.toDouble();

    for (var taskScore in scoredTasks) {
      final task = taskScore.task;
      double remaining = task.requiredTime - assignedTime[task.id]!;
      if (remaining <= 0) continue;

      if (eventMinutes <= remaining) {
        await updateEvent(
          id: event.id,
          title: event.title,
          eventType: event.eventType,
          startTime: event.startTime,
          endTime: event.endTime,
          color: event.color,
          taskId: task.id,
        );
        assignedTime[task.id] = assignedTime[task.id]! + eventMinutes;
        break;
      } else if (remaining > 0 && (eventMinutes - remaining) >= 30) {
        // Only split if the leftover block is at least 20 minutes
        DateTime splitEnd = event.startTime.add(Duration(minutes: remaining.round()));
        // Update first part
        await updateEvent(
          id: event.id,
          title: event.title,
          eventType: event.eventType,
          startTime: event.startTime,
          endTime: splitEnd,
          color: event.color,
          taskId: task.id,
        );
        assignedTime[task.id] = assignedTime[task.id]! + remaining;
        // Create second part for the rest
        DateTime restStart = splitEnd;
        DateTime restEnd = event.endTime;
        if (restStart.isBefore(restEnd)) {
          final newEventId = await addEvent(
            title: event.title,
            eventType: event.eventType,
            startTime: restStart,
            endTime: restEnd,
            color: event.color,
            taskId: null,
          );
          final newEvent = await getEventWithId(idToGet: newEventId);
          if (newEvent != null && newEvent.eventType == 'Study time') {
            studyEvents.add(newEvent);
          }
          }
        break;
      }
    }
  }
}

class _TaskScore {
  final TaskItem task;
  final double score;
  _TaskScore({required this.task, required this.score});
}