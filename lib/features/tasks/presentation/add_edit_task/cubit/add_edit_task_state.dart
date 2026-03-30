sealed class AddEditTaskState {}

class AddEditTaskInitial extends AddEditTaskState {}

class AddEditTaskSaving extends AddEditTaskState {}

class AddEditTaskSuccess extends AddEditTaskState {}

class AddEditTaskFailure extends AddEditTaskState {
  AddEditTaskFailure({required this.message});
  final String message;
}
