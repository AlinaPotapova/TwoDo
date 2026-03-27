import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_do/core/date_utils.dart';
import 'package:two_do/features/tasks/domain/model/task.dart';
import 'package:two_do/features/tasks/domain/task_repository.dart';
import 'package:two_do/features/tasks/presentation/weekly_view/cubit/tasks_state.dart';

/// Cubit for managing the weekly tasks view.
class TasksCubit extends Cubit<TasksState> {
  TasksCubit(TaskRepository repository)
    : _repository = repository,
      super(TasksInitial());

  final TaskRepository _repository;
  final _tasksSubscription = <dynamic>[];

  DateTime _weekStart = DateTime.now();
  List<Task> _allTasks = [];
  TaskFilter _currentFilter = TaskFilter.all;
  TaskSort _currentSort = TaskSort.byDate;

  /// Initialize by loading the current week's tasks.
  void load() {
    emit(TasksLoading());
    _weekStart = getMondayOfWeek(DateTime.now());
    _subscribeToTasks();
  }

  /// Navigate to the previous week.
  void previousWeek() {
    _weekStart = _weekStart.subtract(const Duration(days: 7));
    _updateState();
  }

  /// Navigate to the next week.
  void nextWeek() {
    _weekStart = _weekStart.add(const Duration(days: 7));
    _updateState();
  }

  /// Change the filter.
  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    _updateState();
  }

  /// Change the sort order.
  void setSort(TaskSort sort) {
    if (_currentSort == sort) return;
    _currentSort = sort;

    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      emit(
        TasksLoaded(
          weekStart: currentState.weekStart,
          tasks: currentState.tasks,
          filter: currentState.filter,
          completionPercent: currentState.completionPercent,
          sort: _currentSort,
        ),
      );
    }
  }

  /// Toggle task completion status.
  Future<void> toggleComplete(Task task) async {
    await _repository.toggleComplete(
      task.copyWith(isCompleted: !task.isCompleted),
    );
  }

  /// Subscribe to the tasks stream from the repository.
  void _subscribeToTasks() {
    final subscription = _repository.watchTasks().listen(
      (tasks) {
        _allTasks = tasks;
        _updateState();
      },
      onError: (e) {
        emit(TasksFailure(message: 'Failed to load tasks: $e'));
      },
    );
    _tasksSubscription.add(subscription);
  }

  /// Update the UI state based on current filter and week.
  void _updateState() {
    // weekEnd is exclusive: start of next Monday, so all of Sunday is included
    final weekEnd = _weekStart.add(const Duration(days: 7));

    // Expand tasks based on their repeat type
    final expandedTasks = <Task>[];
    for (final task in _allTasks) {
      if (task.startDate != null) {
        // Tasks with a startDate belong to a specific week — show only then
        final startDate = task.startDate!;
        final isStartDateInWeek =
            !startDate.isBefore(_weekStart) && startDate.isBefore(weekEnd);
        if (isStartDateInWeek) {
          expandedTasks.add(task);
        }
      } else {
        // Tasks without a startDate repeat indefinitely — match by weekday
        final taskIsInWeek = task.dueDays.any((weekday) {
          // weekday is ISO: 1=Mon, 7=Sun
          final targetDate = _weekStart.add(Duration(days: weekday - 1));
          return !targetDate.isBefore(_weekStart) &&
              targetDate.isBefore(weekEnd);
        });

        if (taskIsInWeek) {
          expandedTasks.add(task);
        }
      }
    }

    final filteredTasks =
        expandedTasks.where((task) {
          // Apply filter
          switch (_currentFilter) {
            case TaskFilter.all:
              return true;
            case TaskFilter.mine:
              return task.assignedTo == 'me';
            case TaskFilter.partner:
              return task.assignedTo == 'partner';
          }
        }).toList();

    // Calculate completion percentage
    final completed = filteredTasks.where((t) => t.isCompleted).length;
    final total = filteredTasks.length;
    final percent = total > 0 ? completed / total : 0.0;

    emit(
      TasksLoaded(
        weekStart: _weekStart,
        tasks: filteredTasks,
        filter: _currentFilter,
        completionPercent: percent,
        sort: _currentSort,
      ),
    );
  }

  @override
  Future<void> close() {
    for (final sub in _tasksSubscription) {
      sub.cancel();
    }
    return super.close();
  }
}
