import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';

/// Dedicated Settings Screen
///
/// Demonstrates Global State Management using [Provider]:
/// - Controls global parameters: Theme Mode (Light / Dark / System), Accent Color,
///   Student Profile Name, Course/Section, Student IDs.
/// - Edits made here immediately propagate and update the UI across the entire app
///   (including the Home Dashboard, App Bar, and Activity screens).
class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _courseController;
  late final TextEditingController _idController;
  late final TextEditingController _taglineController;

  final List<Color> _accentColors = const [
    Colors.indigo,
    Colors.teal,
    Colors.deepOrange,
    Colors.purple,
    Colors.green,
    Colors.blue,
  ];

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppStateProvider>();
    _nameController = TextEditingController(text: provider.userName);
    _courseController = TextEditingController(text: provider.courseSection);
    _idController = TextEditingController(text: provider.studentId);
    _taglineController = TextEditingController(text: provider.tagline);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _courseController.dispose();
    _idController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    context.read<AppStateProvider>().updateProfile(
          userName: _nameController.text.trim().isEmpty
              ? 'Student Portfolio'
              : _nameController.text.trim(),
          courseSection: _courseController.text.trim().isEmpty
              ? 'Mobile Computing'
              : _courseController.text.trim(),
          studentId: _idController.text.trim().isEmpty
              ? 'N/A'
              : _idController.text.trim(),
          tagline: _taglineController.text.trim(),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Profile updated! Home Dashboard synchronized instantly.'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = context.watch<AppStateProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Global State explanation banner
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
                    Icon(Icons.sync, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Global State: Modifications to theme and profile are managed via Provider and immediately reflect on the Home Dashboard.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section: Appearance & Theme Mode
              Text(
                'APPEARANCE & THEME',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                ),
                color: isDark
                    ? theme.colorScheme.surfaceContainerHigh
                    : theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theme Mode',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.system,
                            icon: Icon(Icons.brightness_auto),
                            label: Text('System'),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.light,
                            icon: Icon(Icons.light_mode),
                            label: Text('Light'),
                          ),
                          ButtonSegment<ThemeMode>(
                            value: ThemeMode.dark,
                            icon: Icon(Icons.dark_mode),
                            label: Text('Dark'),
                          ),
                        ],
                        selected: {state.themeMode},
                        onSelectionChanged: (Set<ThemeMode> newSelection) {
                          state.setThemeMode(newSelection.first);
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Primary Accent Color',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _accentColors.map((color) {
                          final isSelected = state.seedColor == color;
                          return GestureDetector(
                            onTap: () => state.setSeedColor(color),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 42,
                              height: 42,
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
                                        ),
                                      ]
                                    : [],
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Section: User Profile & Pair Information
              Text(
                'STUDENT / PAIR PROFILE',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                  ),
                ),
                color: isDark
                    ? theme.colorScheme.surfaceContainerHigh
                    : theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Student / Pair Names',
                          prefixIcon: const Icon(Icons.people_outline),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.4,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) {
                          // Real-time update to demonstrate immediate Provider synchronization
                          state.updateProfile(
                            userName: val,
                            courseSection: _courseController.text,
                            studentId: _idController.text,
                            tagline: _taglineController.text,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _courseController,
                        decoration: InputDecoration(
                          labelText: 'Course & Section',
                          prefixIcon: const Icon(Icons.school_outlined),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.4,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) {
                          state.updateProfile(
                            userName: _nameController.text,
                            courseSection: val,
                            studentId: _idController.text,
                            tagline: _taglineController.text,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _idController,
                        decoration: InputDecoration(
                          labelText: 'Student ID Number(s)',
                          prefixIcon: const Icon(Icons.badge_outlined),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.4,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) {
                          state.updateProfile(
                            userName: _nameController.text,
                            courseSection: _courseController.text,
                            studentId: val,
                            tagline: _taglineController.text,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _taglineController,
                        decoration: InputDecoration(
                          labelText: 'Portfolio Description / Tagline',
                          prefixIcon: const Icon(Icons.notes_outlined),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.4,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) {
                          state.updateProfile(
                            userName: _nameController.text,
                            courseSection: _courseController.text,
                            studentId: _idController.text,
                            tagline: val,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _saveProfile,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save Profile Changes', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

