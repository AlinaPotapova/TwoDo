import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:two_do/features/tasks/domain/task_repository.dart';
import 'package:two_do/features/tasks/presentation/weekly_view/builder/tasks_bloc_builder.dart';
import 'package:two_do/features/tasks/presentation/weekly_view/cubit/tasks_cubit.dart';

class WeeklyTasksScreen extends StatelessWidget {
  const WeeklyTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasksCubit(Get.find<TaskRepository>())..load(),
      child: const TasksBlocBuilder(),
    );
  }
}
