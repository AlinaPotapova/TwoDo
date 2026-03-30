import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_do/core/date_utils.dart';
import 'package:two_do/features/tasks/domain/model/task.dart';
import 'package:two_do/features/tasks/presentation/constants.dart';
import 'package:two_do/features/tasks/presentation/add_edit_task/add_edit_task_screen.dart';
import 'package:two_do/features/tasks/presentation/weekly_view/cubit/tasks_cubit.dart';
import 'package:two_do/features/tasks/presentation/weekly_view/cubit/tasks_state.dart'
    show TasksState, TasksLoaded, TasksFailure, TaskFilter, TaskSort;

class WeeklyTasksContent extends StatelessWidget {
  const WeeklyTasksContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        return switch (state) {
          TasksLoaded(
            :final weekStart,
            :final tasks,
            :final filter,
            :final completionPercent,
            :final sort,
          ) =>
            _buildLoaded(
              context,
              weekStart,
              tasks,
              filter,
              completionPercent,
              sort,
            ),
          TasksFailure(:final message) => _buildError(context, message),
          _ => _buildLoading(),
        };
      },
    );
  }

  Widget _buildLoading() {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: Text(
          'Error: $message',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    DateTime weekStart,
    List<Task> tasks,
    TaskFilter filter,
    double completionPercent,
    TaskSort sort,
  ) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: scheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: _WeekRangeTitle(weekStart),
        actions: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: scheme.onSurface, size: 28),
            onPressed: () => context.read<TasksCubit>().previousWeek(),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: scheme.onSurface, size: 28),
            onPressed: () => context.read<TasksCubit>().nextWeek(),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            backgroundColor: scheme.surface,
            elevation: 0,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: _ProgressBar(completionPercent, sort),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _FilterChips(filter),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              _buildDaySections(context, weekStart, tasks, sort),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: scheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
          );
        },
        child: Icon(Icons.add, color: scheme.onPrimary),
      ),
    );
  }

  List<Widget> _buildDaySections(
    BuildContext context,
    DateTime weekStart,
    List<Task> allTasks,
    TaskSort sort,
  ) {
    final days = dayNames;
    final scheme = Theme.of(context).colorScheme;
    final sections = <Widget>[];

    // Determine if current week and day order
    final now = DateTime.now();
    final currentWeekMonday = getMondayOfWeek(weekStart);
    final isCurrentWeek = weekStart == currentWeekMonday;
    final startOffset = isCurrentWeek ? (now.weekday - 1) : 0;
    final indices = List.generate(7, (i) => (startOffset + i) % 7);

    for (int idx in indices) {
      final dayDate = weekStart.add(Duration(days: idx));
      final isoWeekday = dayDate.weekday;
      final dayName = days[idx];
      final dateStr =
          '${dayDate.day}.${dayDate.month.toString().padLeft(2, '0')}';

      // Filter tasks for this day
      var dayTasks =
          allTasks.where((t) => t.dueDays.contains(isoWeekday)).toList();

      // Apply sorting
      dayTasks.sort((a, b) {
        switch (sort) {
          case TaskSort.byDate:
            final aTime = a.dueTime ?? '99:99';
            final bTime = b.dueTime ?? '99:99';
            return aTime.compareTo(bTime);
          case TaskSort.byAssignee:
            return a.assignedTo.compareTo(b.assignedTo);
        }
      });

      sections.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$dayName · $dateStr',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (dayTasks.isEmpty)
                _EmptyDay(scheme)
              else
                ...dayTasks.map(
                  (task) => _TaskCard(
                    task: task,
                    onToggle: () {
                      context.read<TasksCubit>().toggleComplete(task);
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // Add bottom padding
    sections.add(const SizedBox(height: 100));

    return sections;
  }
}

class _WeekRangeTitle extends StatelessWidget {
  const _WeekRangeTitle(this.weekStart);
  final DateTime weekStart;

  String _label() {
    final weekEnd = weekStart.add(const Duration(days: 6));
    final startMonth = monthNames[weekStart.month - 1].substring(0, 3);
    if (weekStart.month == weekEnd.month) {
      return '$startMonth ${weekStart.day} - ${weekEnd.day}';
    }
    final endMonth = monthNames[weekEnd.month - 1].substring(0, 3);
    return '$startMonth ${weekStart.day} - $endMonth ${weekEnd.day}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      _label(),
      style: TextStyle(
        color: scheme.onSurface,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar(this.percent, this.sort);
  final double percent;
  final TaskSort sort;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cubit = context.read<TasksCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weekly Progress',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  '${(percent * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                PopupMenuButton<TaskSort>(
                  icon: Icon(
                    Icons.sort,
                    color: scheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onSelected: cubit.setSort,
                  itemBuilder:
                      (_) => [
                        PopupMenuItem(
                          value: TaskSort.byDate,
                          child: Row(
                            children: [
                              Icon(Icons.access_time, size: 16),
                              const SizedBox(width: 8),
                              const Text('By Date'),
                              if (sort == TaskSort.byDate) ...[
                                const Spacer(),
                                Icon(Icons.check, size: 16),
                              ],
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: TaskSort.byAssignee,
                          child: Row(
                            children: [
                              Icon(Icons.person_outline, size: 16),
                              const SizedBox(width: 8),
                              const Text('By Assignee'),
                              if (sort == TaskSort.byAssignee) ...[
                                const Spacer(),
                                Icon(Icons.check, size: 16),
                              ],
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: scheme.outlineVariant.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation(scheme.primary),
          ),
        ),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips(this.currentFilter);
  final TaskFilter currentFilter;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TasksCubit>();

    return Row(
      children: [
        ChoiceChip(
          avatar: const Icon(Icons.tune, size: 16),
          label: const Text('All'),
          selected: currentFilter == TaskFilter.all,
          onSelected: (_) => cubit.setFilter(TaskFilter.all),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          avatar: const CircleAvatar(
            backgroundColor: Colors.green,
            child: Text(
              'M',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          label: const Text('My Tasks'),
          selected: currentFilter == TaskFilter.mine,
          onSelected: (_) => cubit.setFilter(TaskFilter.mine),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          avatar: const CircleAvatar(
            backgroundColor: Colors.purple,
            child: Text(
              'P',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          label: const Text("Partner's"),
          selected: currentFilter == TaskFilter.partner,
          onSelected: (_) => cubit.setFilter(TaskFilter.partner),
        ),
      ],
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task, required this.onToggle});

  final Task task;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (_) => onToggle(),
              activeColor: scheme.primary,
              side: BorderSide(color: scheme.outline, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface,
                        decoration:
                            task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                        decorationColor: scheme.onSurface,
                      ),
                    ),
                    if (task.dueTime != null)
                      Text(
                        task.dueTime!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            CircleAvatar(
              radius: 16,
              backgroundColor:
                  task.assignedTo == 'me' ? Colors.green : Colors.purple,
              child: Text(
                task.assignedTo == 'me' ? 'M' : 'P',
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay(this.scheme);
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 40,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'No tasks scheduled. Enjoy your day!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
