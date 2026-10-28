import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';

/// Activity 1: Interactive Counter & Dynamic Card Studio
///
/// Demonstrates [StatefulWidget] for local, screen-specific interactions:
/// - Local mutable state (`_counter`, `_step`, `_selectedColorIndex`, `_actionLog`)
/// - `setState()` triggering targeted UI rebuilds
/// - Responsive layout using [SingleChildScrollView], [Column], [Row], [Expanded], [Flexible]
class Activity1Screen extends StatefulWidget {
  static const String routeName = '/activity1';

  const Activity1Screen({super.key});

  @override
  State<Activity1Screen> createState() => _Activity1ScreenState();
}

class _Activity1ScreenState extends State<Activity1Screen> {
  // Local Screen-Specific State
  int _counter = 0;
  int _step = 1;
  int _selectedColorIndex = 0;
  final List<String> _actionLog = [];

  final List<Color> _palette = [
    Colors.indigo,
    Colors.teal,
    Colors.deepOrange,
    Colors.purple,
    Colors.blueGrey,
  ];

  void _increment() {
    setState(() {
      _counter += _step;
      _logAction('Incremented by +$_step (Result: $_counter)');
    });
  }

  void _decrement() {
    setState(() {
      _counter -= _step;
      _logAction('Decremented by -$_step (Result: $_counter)');
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
      _logAction('Reset counter back to 0');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Counter reset to zero'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _logAction(String msg) {
    final time = DateTime.now();
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
    _actionLog.insert(0, '[$timeStr] $msg');
    if (_actionLog.length > 15) {
      _actionLog.removeLast();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = _palette[_selectedColorIndex];
    final appState = context.watch<AppStateProvider>();
    final isCompleted = appState.isActivityCompleted('act-1');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity 1: Interactive Counter'),
        actions: [
          IconButton(
            tooltip: isCompleted ? 'Mark as Incomplete' : 'Mark as Completed',
            icon: Icon(
              isCompleted ? Icons.check_circle : Icons.check_circle_outline,
              color: isCompleted ? Colors.green : null,
            ),
            onPressed: () {
              appState.toggleActivityCompleted('act-1');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isCompleted
                        ? 'Activity 1 marked incomplete'
                        : 'Activity 1 marked as Completed! Great job!',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Screen Concept Description Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This screen uses StatefulWidget for local counter state and integrates with global Provider for completion status.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Dynamic Interactive Display Card
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                decoration: BoxDecoration(
                  color: activeColor.withValues(alpha: isDark ? 0.25 : 0.12),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: activeColor.withValues(alpha: 0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'CURRENT VALUE',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: activeColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$_counter',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: activeColor,
                        fontSize: 64,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: activeColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _counter == 0
                            ? 'Neutral State'
                            : _counter > 0
                                ? 'Positive (+$_counter)'
                                : 'Negative ($_counter)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: activeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Responsive Increment/Decrement Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _decrement,
                      icon: const Icon(Icons.remove_circle_outline),
                      label: Text('-$_step', style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filledTonal(
                    tooltip: 'Reset to Zero',
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: activeColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _increment,
                      icon: const Icon(Icons.add_circle_outline),
                      label: Text('+$_step', style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Step Selection Segmented Control
              Text(
                'Step Size Modifier',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment<int>(value: 1, label: Text('Step 1')),
                  ButtonSegment<int>(value: 5, label: Text('Step 5')),
                  ButtonSegment<int>(value: 10, label: Text('Step 10')),
                  ButtonSegment<int>(value: 50, label: Text('Step 50')),
                ],
                selected: {_step},
                onSelectionChanged: (Set<int> newSelection) {
                  setState(() {
                    _step = newSelection.first;
                    _logAction('Changed step size to $_step');
                  });
                },
              ),
              const SizedBox(height: 20),

              // Dynamic Color Palette Selector
              Text(
                'Card Accent Color',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_palette.length, (index) {
                  final color = _palette[index];
                  final isSelected = _selectedColorIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColorIndex = index;
                        _logAction('Selected new card color');
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.6),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                )
                              ]
                            : [],
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : null,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Local Activity Event Log (Stateful History)
              Row(
                children: [
                  Icon(Icons.history, size: 18, color: theme.colorScheme.secondary),
                  const SizedBox(width: 8),
                  Text(
                    'State Interaction History',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (_actionLog.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _actionLog.clear();
                        });
                      },
                      child: const Text('Clear Log'),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 180),
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.surfaceContainerHighest
                      : theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: _actionLog.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            'No actions yet. Tap +/- or adjust steps to interact.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _actionLog.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            child: Text(
                              _actionLog[index],
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

