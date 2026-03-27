import 'package:two_do/core/result_widget.dart';
import 'package:two_do/features/tasks/domain/model/task.dart';

/// Repository for task operations.
abstract class TaskRepository {
  /// Returns a stream of all tasks for the current user.
  Stream<List<Task>> watchTasks();

  /// Adds a new task. Returns the generated task ID.
  Future<Result<String>> addTask(Task task);

  /// Updates an existing task.
  Future<Result<void>> updateTask(Task task);

  /// Toggles the completion status of a task.
  Future<Result<void>> toggleComplete(Task task);

  /// Deletes a task.
  Future<Result<void>> deleteTask(String taskId);
}
