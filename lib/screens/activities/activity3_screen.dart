import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';

class _LabTask {
  final String id;
  String title;
  bool isDone;

  _LabTask({required this.id, required this.title, this.isDone = false});
}

/// Activity 3: Lab Milestone & Checklist Manager
///
/// Demonstrates [StatefulWidget] managing dynamic list mutations:
/// - Adding new items from dialog input
/// - Toggling checked status
/// - Deleting items with animated SnackBar undo option
class Activity3Screen extends StatefulWidget {
  static const String routeName = '/activity3';

  const Activity3Screen({super.key});

  @override
  State<Activity3Screen> createState() => _Activity3ScreenState();
}

class _Activity3ScreenState extends State<Activity3Screen> {
  final List<_LabTask> _tasks = [
    _LabTask(id: '1', title: 'Complete Lab 1: UI & Layout Architecture', isDone: true),
    _LabTask(id: '2', title: 'Setup Provider State Management across screens', isDone: true),
    _LabTask(id: '3', title: 'Implement Responsive Breakpoints & Flex layouts', isDone: false),
    _LabTask(id: '4', title: 'Prepare Pair Presentation & Code walkthrough', isDone: false),
  ];

  void _addTask(String title) {
    if (title.trim().isEmpty) return;
    setState(() {
      _tasks.add(_LabTask(id: DateTime.now().toString(), title: title.trim()));
    });
  }

  void _showAddDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Activity Goal'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter milestone or task description...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              _addTask(controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Add Goal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateProvider>();
    final isCompleted = appState.isActivityCompleted('act-3');

    final completedCount = _tasks.where((t) => t.isDone).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity 3: Lab Checklist'),
        actions: [
          IconButton(
            tooltip: isCompleted ? 'Mark as Incomplete' : 'Mark as Completed',
            icon: Icon(
              isCompleted ? Icons.check_circle : Icons.check_circle_outline,
              color: isCompleted ? Colors.green : null,
            ),
            onPressed: () {
              appState.toggleActivityCompleted('act-3');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add_task),
        label: const Text('Add Milestone'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar Header
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceContainerHigh
                    : theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Checklist Progress',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$completedCount of ${_tasks.length} Done',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: _tasks.isEmpty ? 0 : completedCount / _tasks.length,
                    borderRadius: BorderRadius.circular(8),
                    minHeight: 8,
                  ),
                ],
              ),
            ),

            // Dynamic Task List
            Expanded(
              child: _tasks.isEmpty
                  ? Center(
                      child: Text(
                        'No milestones added yet. Tap below to create one!',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _tasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: theme.colorScheme.outlineVariant.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          child: CheckboxListTile(
                            value: task.isDone,
                            onChanged: (val) {
                              setState(() {
                                task.isDone = val ?? false;
                              });
                            },
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: task.isDone
                                    ? theme.colorScheme.onSurfaceVariant
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                            secondary: Icon(
                              task.isDone
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              color: task.isDone ? Colors.green : null,
                            ),
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

