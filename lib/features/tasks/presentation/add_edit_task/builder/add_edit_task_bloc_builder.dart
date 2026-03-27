import 'package:flutter/material.dart';
import 'package:two_do/shared/custom_builder.dart';
import 'package:two_do/features/tasks/presentation/add_edit_task/content/add_edit_task_content.dart';
import 'package:two_do/features/tasks/presentation/add_edit_task/cubit/add_edit_task_cubit.dart';
import 'package:two_do/features/tasks/presentation/add_edit_task/cubit/add_edit_task_state.dart';

/// Builder wrapper for AddEditTaskCubit that handles success and error cases.
class AddEditTaskBlocBuilder extends StatelessWidget {
  const AddEditTaskBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocBuilder<AddEditTaskCubit, AddEditTaskState>(
      listenWhen: (_, state) => state is AddEditTaskSuccess || state is AddEditTaskFailure,
      listener: (context, state) {
        if (state is AddEditTaskSuccess) {
          Navigator.pop(context, true);
        } else if (state is AddEditTaskFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) => const AddEditTaskContent(),
    );
  }
}
