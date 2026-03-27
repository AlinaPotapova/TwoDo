/// Represents a task in the weekly task list.
///
/// [dueDays] uses ISO weekday convention: 1=Monday, 7=Sunday.
class Task {
  final String id;
  final String title;
  final String? description;
  final String assignedTo;        // 'me' or 'partner'
  final List<int> dueDays;        // ISO weekdays: 1=Mon … 7=Sun
  final String repeatType;        // 'none' | 'daily' | 'weekly'
  final bool isCompleted;
  final String? dueTime;          // 'HH:mm' format or null
  final DateTime? startDate;      // When the task becomes active

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.assignedTo,
    required this.dueDays,
    required this.repeatType,
    required this.isCompleted,
    this.dueTime,
    this.startDate,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? assignedTo,
    List<int>? dueDays,
    String? repeatType,
    bool? isCompleted,
    String? dueTime,
    DateTime? startDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedTo: assignedTo ?? this.assignedTo,
      dueDays: dueDays ?? this.dueDays,
      repeatType: repeatType ?? this.repeatType,
      isCompleted: isCompleted ?? this.isCompleted,
      dueTime: dueTime ?? this.dueTime,
      startDate: startDate ?? this.startDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'dueDays': dueDays,
      'repeatType': repeatType,
      'isCompleted': isCompleted,
      'dueTime': dueTime,
      'startDate': startDate?.millisecondsSinceEpoch,
    };
  }

  factory Task.fromMap(String id, Map<dynamic, dynamic> map) {
    return Task(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String?,
      assignedTo: map['assignedTo'] as String? ?? 'me',
      dueDays: List<int>.from(map['dueDays'] as List<dynamic>? ?? [1]),
      repeatType: map['repeatType'] as String? ?? 'none',
      isCompleted: map['isCompleted'] as bool? ?? false,
      dueTime: map['dueTime'] as String?,
      startDate: map['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int)
          : null,
    );
  }
}
