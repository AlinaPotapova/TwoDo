sealed class AddEditTaskState {}

class AddEditTaskInitial extends AddEditTaskState {}

class AddEditTaskSaving extends AddEditTaskState {}

class AddEditTaskSuccess extends AddEditTaskState {}

/// Task was written to the local Firebase queue while offline.
/// It will sync to the server automatically when connectivity is restored.
class AddEditTaskSavedLocally extends AddEditTaskState {}

class AddEditTaskFailure extends AddEditTaskState {
  AddEditTaskFailure({required this.message});
  final String message;
}
