import 'package:two_do/features/tasks/domain/model/task.dart';

sealed class TasksState {}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  TasksLoaded({
    required this.weekStart,
    required this.tasks,
    required this.filter,
    required this.completionPercent,
    required this.sort,
    required this.isOffline,
  });

  final DateTime weekStart;             // Monday of displayed week
  final List<Task> tasks;               // filtered tasks for this week
  final TaskFilter filter;
  final double completionPercent;       // 0.0–1.0
  final TaskSort sort;
  final bool isOffline;
}

class TasksFailure extends TasksState {
  TasksFailure({required this.message});
  final String message;
}

enum TaskFilter { all, mine, partner }
enum TaskSort { byDate, byAssignee }
