import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:two_do/features/tasks/domain/model/task.dart';
import 'package:two_do/features/tasks/domain/task_repository.dart';
import 'package:two_do/features/tasks/presentation/add_edit_task/builder/add_edit_task_bloc_builder.dart';
import 'package:two_do/features/tasks/presentation/add_edit_task/cubit/add_edit_task_cubit.dart';

class AddEditTaskScreen extends StatelessWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddEditTaskCubit(Get.find<TaskRepository>(), existing: task),
      child: const AddEditTaskBlocBuilder(),
    );
  }
}
