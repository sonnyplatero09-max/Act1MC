import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity_model.dart';
import '../providers/app_state_provider.dart';
import '../widgets/activity_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/metric_card.dart';
import 'activities/activity1_screen.dart';
import 'activities/activity2_screen.dart';
import 'activities/activity3_screen.dart';
import 'settings_screen.dart';

/// Home Dashboard Screen
///
/// Serves as the master compilation hub for all laboratory activities.
/// - Demonstrates declarative UI architecture
/// - Uses [Row], [Column], [Expanded], [Flexible], and [LayoutBuilder] for responsive adaptation
/// - Listens to [AppStateProvider] for dynamic theme, profile name, and metrics updates
class HomeDashboardScreen extends StatefulWidget {
  static const String routeName = '/';

  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  String _searchQuery = '';

  // Master compilation registry of activities
  static const List<ActivityItem> _activities = [
    ActivityItem(
      id: 'act-1',
      title: 'Activity 1: Interactive Counter Studio',
      subtitle: 'Local State & Interactive Widget Architecture',
      description:
          'Demonstrates StatefulWidget lifecycle, local state mutation with setState, step modifiers, and custom card theming.',
      icon: Icons.add_circle_outline_rounded,
      accentColor: Colors.indigo,
      routeName: Activity1Screen.routeName,
      tags: ['StatefulWidget', 'Local State', 'Responsive Layout'],
    ),
    ActivityItem(
      id: 'act-2',
      title: 'Activity 2: Tip & Bill Splitter',
      subtitle: 'Dynamic Form Calculation & Real-Time Layout',
      description:
          'Demonstrates responsive mathematical UI, slider controls, currency formatting, and multi-tier bill breakdown cards.',
      icon: Icons.calculate_outlined,
      accentColor: Colors.teal,
      routeName: Activity2Screen.routeName,
      tags: ['Calculations', 'TextController', 'Row & Expanded'],
    ),
    ActivityItem(
      id: 'act-3',
      title: 'Activity 3: Lab Checklist & Milestones',
      subtitle: 'Dynamic List State & Progress Tracking',
      description:
          'Demonstrates stateful dynamic list mutations, modal dialog item creation, task toggling, and visual progress calculation.',
      icon: Icons.checklist_rtl_rounded,
      accentColor: Colors.deepOrange,
      routeName: Activity3Screen.routeName,
      tags: ['Dynamic Lists', 'Progress Bar', 'Dialogs'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppStateProvider>();

    final filteredActivities = _activities.where((activity) {
      final query = _searchQuery.toLowerCase();
      return activity.title.toLowerCase().contains(query) ||
          activity.subtitle.toLowerCase().contains(query) ||
          activity.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();

    final completedCount = appState.completedActivityIds.length;
    final totalCount = _activities.length;
    final completionPct = totalCount > 0 ? (completedCount / totalCount * 100).toInt() : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Computing Portfolio'),
        actions: [
          IconButton(
            tooltip: 'Settings & Theme',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, SettingsScreen.routeName);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Header with Student Profile & Live Theme Toggle
              const DashboardHeader(),
              const SizedBox(height: 16),

              // Responsive Metric Cards Row
              LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive adaptation: If width is small, use 2-per-row or vertical flex
                  final isWide = constraints.maxWidth > 500;
                  return Row(
                    children: [
                      Expanded(
                        child: MetricCard(
                          label: 'Completed',
                          value: '$completedCount / $totalCount ($completionPct%)',
                          icon: Icons.task_alt_rounded,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MetricCard(
                          label: 'Active Theme',
                          value: appState.themeMode == ThemeMode.dark
                              ? 'Dark Mode'
                              : appState.themeMode == ThemeMode.light
                                  ? 'Light Mode'
                                  : 'System',
                          icon: appState.themeMode == ThemeMode.dark
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // Search & Filter Bar
              SearchBar(
                hintText: 'Search laboratory activities or tags...',
                leading: const Icon(Icons.search),
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: WidgetStatePropertyAll(
                  theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                ),
                trailing: _searchQuery.isNotEmpty
                    ? [
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        ),
                      ]
                    : null,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Section Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Laboratory Activities',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${filteredActivities.length} available',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Activity Cards List
              if (filteredActivities.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No activities found matching "$_searchQuery"',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...filteredActivities.map((activity) {
                  final isDone = appState.isActivityCompleted(activity.id);
                  return ActivityCard(
                    item: activity,
                    isCompleted: isDone,
                    onTap: () {
                      Navigator.pushNamed(context, activity.routeName);
                    },
                    onToggleCompleted: () {
                      appState.toggleActivityCompleted(activity.id);
                    },
                  );
                }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

