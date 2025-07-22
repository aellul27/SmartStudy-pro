class TaskItem {
  final int id;
  final String title;
  final String subject;
  final int requiredTime;
  final DateTime dueDate;
  final int priority;
  final bool completed;

  TaskItem(this.id,this.title, this.subject, this.requiredTime, this.dueDate, this.priority, this.completed);
}