class Task {
  String title;
  String priority;
  bool isCompleted;

  Task({
    required this.title,
    this.priority = 'Medium',
    this.isCompleted = false,
  });
}
