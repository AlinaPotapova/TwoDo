import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_do/features/tasks/presentation/add_edit_task/cubit/add_edit_task_cubit.dart';
import 'package:two_do/features/tasks/presentation/constants.dart';

class AddEditTaskContent extends StatefulWidget {
  const AddEditTaskContent({super.key});

  @override
  State<AddEditTaskContent> createState() => _AddEditTaskContentState();
}

class _AddEditTaskContentState extends State<AddEditTaskContent> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  String _selectedAssignee = 'me';
  String _selectedRepeat = 'none';
  DateTime? _selectedStartDate;

  @override
  void initState() {
    super.initState();
    _selectedStartDate = DateTime.now();
    _formKey = GlobalKey<FormState>();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: scheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Task',
          style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: scheme.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Name
              Text(
                'Task Name',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'e.g., Take out the trash',
                  filled: true,
                  fillColor: scheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: scheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: scheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: scheme.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Task name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Description
              Text(
                'Description (Optional)',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "e.g., Don't forget the recycling bin",
                  filled: true,
                  fillColor: scheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: scheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: scheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: scheme.primary, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),

              // Assign To
              Text(
                'Assign To',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _AssigneeSelector(
                selectedAssignee: _selectedAssignee,
                onChanged: (assignee) {
                  setState(() => _selectedAssignee = assignee);
                },
              ),
              const SizedBox(height: 24),

              // Repeats
              Text(
                'Repeats',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedRepeat,
                items: [
                  DropdownMenuItem(value: repeatTypeNone, child: Text('None')),
                  DropdownMenuItem(value: repeatTypeDaily, child: Text('Every Day')),
                  DropdownMenuItem(value: repeatTypeWeekly, child: Text('Every Week')),
                ]
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedRepeat = value);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: scheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: scheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: scheme.outline),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),

              // Start Date
              Text(
                'Start Date',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _StartDatePicker(
                selectedDate: _selectedStartDate,
                onDateSelected: (date) {
                  setState(() => _selectedStartDate = date);
                },
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        color: scheme.surface,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final startDate = _selectedStartDate ?? DateTime.now();
              context.read<AddEditTaskCubit>().save(
                title: _titleController.text,
                description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
                assignedTo: _selectedAssignee,
                dueDays: [startDate.weekday],
                repeatType: _selectedRepeat,
                startDate: startDate,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: scheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            'Save Task',
            style: TextStyle(
              color: scheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _AssigneeSelector extends StatelessWidget {
  const _AssigneeSelector({
    required this.selectedAssignee,
    required this.onChanged,
  });

  final String selectedAssignee;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(assigneeMe),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.green,
                  child: Text('M', style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Me',
                  style: TextStyle(
                    color: selectedAssignee == assigneeMe ? scheme.primary : scheme.onSurfaceVariant,
                    fontWeight: selectedAssignee == assigneeMe ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                if (selectedAssignee == assigneeMe)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 2,
                    width: 30,
                    color: scheme.primary,
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(assigneePartner),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.purple,
                  child: Text('P', style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Partner',
                  style: TextStyle(
                    color: selectedAssignee == assigneePartner ? scheme.primary : scheme.onSurfaceVariant,
                    fontWeight: selectedAssignee == assigneePartner ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                if (selectedAssignee == assigneePartner)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 2,
                    width: 30,
                    color: scheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StartDatePicker extends StatelessWidget {
  const _StartDatePicker({
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  String _formatDate(DateTime date) {
    return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border.all(color: scheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? _formatDate(selectedDate!)
                  : 'e.g., Oct 24, 2023',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: selectedDate != null ? scheme.onSurface : scheme.onSurfaceVariant,
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: scheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
