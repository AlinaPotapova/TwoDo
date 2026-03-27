import 'package:flutter/material.dart';
import 'package:two_do/shared/custom_builder.dart';
import 'package:two_do/features/tasks/presentation/weekly_view/content/weekly_tasks_content.dart';
import 'package:two_do/features/tasks/presentation/weekly_view/cubit/tasks_cubit.dart';
import 'package:two_do/features/tasks/presentation/weekly_view/cubit/tasks_state.dart';

/// Builder wrapper for TasksCubit that handles errors and navigation.
class TasksBlocBuilder extends StatelessWidget {
  const TasksBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocBuilder<TasksCubit, TasksState>(
      listenWhen: (_, state) => state is TasksFailure,
      listener: (context, state) {
        if (state is TasksFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) => const WeeklyTasksContent(),
    );
  }
}
