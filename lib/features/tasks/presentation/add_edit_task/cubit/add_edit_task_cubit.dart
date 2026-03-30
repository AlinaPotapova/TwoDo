import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_do/core/result_widget.dart';
import 'package:two_do/features/tasks/domain/model/task.dart';
import 'package:two_do/features/tasks/domain/task_repository.dart';
import 'package:two_do/features/tasks/presentation/add_edit_task/cubit/add_edit_task_state.dart';

/// Cubit for adding or editing a task.
class AddEditTaskCubit extends Cubit<AddEditTaskState> {
  AddEditTaskCubit(TaskRepository repository, {Task? existing})
    : _repository = repository,
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

    if (repeatType != 'none') {
      if (_existingTask != null) {
        await _repository.deleteTask(_existingTask.id);
      }
      await _saveRecurringTasks(
        title: title,
        description: description,
        assignedTo: assignedTo,
        repeatType: repeatType,
        startDate: startDate,
      );
      return;
    }

    final task =
        _existingTask?.copyWith(
          title: title,
          description: description,
          assignedTo: assignedTo,
          dueDays: dueDays,
          repeatType: repeatType,
          startDate: startDate,
        ) ??
        Task(
          id: '',
          title: title,
          description: description,
          assignedTo: assignedTo,
          dueDays: dueDays,
          repeatType: repeatType,
          isCompleted: false,
          startDate: startDate,
        );

    final result =
        _existingTask == null
            ? await _repository.addTask(task)
            : await _repository.updateTask(task);

    switch (result) {
      case Success():
        emit(AddEditTaskSuccess());
      case Failure(:final message):
        emit(AddEditTaskFailure(message: message));
    }
  }

  /// Creates one task per occurrence (day or week) from startDate until end of month.
  Future<void> _saveRecurringTasks({
    required String title,
    String? description,
    required String assignedTo,
    required String repeatType,
    DateTime? startDate,
  }) async {
    final start = _toMidnight(startDate ?? DateTime.now());
    final lastDayOfMonth = DateTime(start.year, start.month + 1, 0);
    final step =
        repeatType == 'daily'
            ? const Duration(days: 1)
            : const Duration(days: 7);

    final futures = <Future<Result<String>>>[];

    for (
      DateTime date = start;
      !date.isAfter(lastDayOfMonth);
      date = date.add(step)
    ) {
      futures.add(
        _repository.addTask(
          Task(
            id: '',
            title: title,
            description: description,
            assignedTo: assignedTo,
            dueDays: [date.weekday],
            repeatType: repeatType,
            isCompleted: false,
            startDate: date,
          ),
        ),
      );
    }

    final results = await Future.wait(futures);

    if (results.every((r) => r is Success)) {
      emit(AddEditTaskSuccess());
    } else {
      emit(
        AddEditTaskFailure(message: 'Failed to create some $repeatType tasks'),
      );
    }
  }

  /// Normalize a DateTime to midnight to avoid time-component issues in week filtering.
  DateTime _toMidnight(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
