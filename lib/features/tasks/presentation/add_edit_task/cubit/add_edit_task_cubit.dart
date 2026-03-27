import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_do/core/result_widget.dart';
import 'package:two_do/features/tasks/domain/model/task.dart';
import 'package:two_do/features/tasks/domain/task_repository.dart';
import 'package:two_do/features/tasks/presentation/add_edit_task/cubit/add_edit_task_state.dart';

/// Cubit for adding or editing a task.
class AddEditTaskCubit extends Cubit<AddEditTaskState> {
  AddEditTaskCubit(
    TaskRepository repository, {
    Task? existing,
  })  : _repository = repository,
        _existingTask = existing,
        super(AddEditTaskInitial());

  final TaskRepository _repository;
  final Task? _existingTask;

  /// Save the task (add or edit).
  Future<void> save({
    required String title,
    String? description,
    required String assignedTo,
    required List<int> dueDays,
    required String repeatType,
    DateTime? startDate,
  }) async {
    emit(AddEditTaskSaving());

    // For daily tasks, create individual tasks for each day until end of month
    if (repeatType == 'daily' && _existingTask == null) {
      await _saveDailyTasks(
        title: title,
        description: description,
        assignedTo: assignedTo,
        dueDays: dueDays,
        startDate: startDate,
      );
    } else if (repeatType == 'weekly' && _existingTask == null) {
      // For weekly tasks, create individual tasks for each matching weekday until end of month
      await _saveWeeklyTasks(
        title: title,
        description: description,
        assignedTo: assignedTo,
        dueDays: dueDays,
        startDate: startDate,
      );
    } else {
      // For 'none' type or edits, save as single task
      final task = (_existingTask?.copyWith(
            title: title,
            description: description,
            assignedTo: assignedTo,
            dueDays: dueDays,
            repeatType: repeatType,
            startDate: startDate,
          )) ??
          Task(
            id: '', // Will be set by Firebase
            title: title,
            description: description,
            assignedTo: assignedTo,
            dueDays: dueDays,
            repeatType: repeatType,
            isCompleted: false,
            startDate: startDate,
          );

      final result = _existingTask == null
          ? await _repository.addTask(task)
          : await _repository.updateTask(task);

      switch (result) {
        case Success():
          emit(AddEditTaskSuccess());
        case Failure(:final message):
          emit(AddEditTaskFailure(message: message));
      }
    }
  }

  /// Save daily tasks: create individual tasks for each day until end of month.
  Future<void> _saveDailyTasks({
    required String title,
    required String? description,
    required String assignedTo,
    required List<int> dueDays,
    DateTime? startDate,
  }) async {
    final start = startDate ?? DateTime.now();
    final lastDayOfMonth = DateTime(start.year, start.month + 1, 0);

    // If creating a new task, generate one for each day from start until end of month
    List<Future<Result<String>>> futures = [];

    for (DateTime date = start; !date.isAfter(lastDayOfMonth); date = date.add(const Duration(days: 1))) {
      final task = Task(
        id: '', // Will be set by Firebase
        title: title,
        description: description,
        assignedTo: assignedTo,
        dueDays: [date.weekday], // Each task has only its own weekday
        repeatType: 'none', // Independent tasks, not repeating
        isCompleted: false,
        startDate: date,
      );
      futures.add(_repository.addTask(task));
    }

    final results = await Future.wait(futures);

    // Check if all succeeded
    final allSuccess = results.every((r) => r is Success);

    if (allSuccess) {
      emit(AddEditTaskSuccess());
    } else {
      emit(AddEditTaskFailure(message: 'Failed to create some daily tasks'));
    }
  }

  /// Save weekly tasks: create individual tasks for each matching weekday until end of month.
  Future<void> _saveWeeklyTasks({
    required String title,
    required String? description,
    required String assignedTo,
    required List<int> dueDays,
    DateTime? startDate,
  }) async {
    final start = startDate ?? DateTime.now();
    final lastDayOfMonth = DateTime(start.year, start.month + 1, 0);

    List<Future<Result<String>>> futures = [];

    // Create tasks for each matching weekday until end of month
    DateTime currentDate = start;
    while (!currentDate.isAfter(lastDayOfMonth)) {
      final task = Task(
        id: '', // Will be set by Firebase
        title: title,
        description: description,
        assignedTo: assignedTo,
        dueDays: [currentDate.weekday], // Each task has only its own weekday
        repeatType: 'none', // Independent tasks, not repeating
        isCompleted: false,
        startDate: currentDate,
      );
      futures.add(_repository.addTask(task));
      currentDate = currentDate.add(const Duration(days: 7));
    }

    final results = await Future.wait(futures);

    // Check if all succeeded
    final allSuccess = results.every((r) => r is Success);

    if (allSuccess) {
      emit(AddEditTaskSuccess());
    } else {
      emit(AddEditTaskFailure(message: 'Failed to create some weekly tasks'));
    }
  }
}
