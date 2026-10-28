import 'package:flutter/material.dart';

/// Global state provider managing:
/// 1. Application Theme (Light / Dark / System mode and accent seed color)
/// 2. User Profile (Student/Pair names, course/section, student IDs)
/// 3. Laboratory Progress tracking (completed activities)
///
/// Implements [ChangeNotifier] so any widget listening to this provider
/// will automatically rebuild whenever [notifyListeners()] is called.
class AppStateProvider extends ChangeNotifier {
  // --- Theme State ---
  ThemeMode _themeMode = ThemeMode.system;
  Color _seedColor = Colors.indigo;

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.dark) return true;
    if (_themeMode == ThemeMode.light) return false;
    // Default to system brightness check if needed, or false
    return false;
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  void setSeedColor(Color color) {
    _seedColor = color;
    notifyListeners();
  }

  // --- Profile State ---
  String _userName = 'Alex Rivera & Sam Cruz';
  String _courseSection = 'BSIT 3-A • Mobile Computing';
  String _studentId = 'MC-2026-001 / MC-2026-002';
  String _tagline = 'Master Laboratory Compilation & Flutter Portfolio';

  String get userName => _userName;
  String get courseSection => _courseSection;
  String get studentId => _studentId;
  String get tagline => _tagline;

  void updateProfile({
    required String userName,
    required String courseSection,
    required String studentId,
    required String tagline,
  }) {
    _userName = userName;
    _courseSection = courseSection;
    _studentId = studentId;
    _tagline = tagline;
    notifyListeners();
  }

  // --- Laboratory Progress Tracking ---
  final Set<String> _completedActivityIds = {'act-1'};

  Set<String> get completedActivityIds => _completedActivityIds;

  bool isActivityCompleted(String activityId) {
    return _completedActivityIds.contains(activityId);
  }

  void toggleActivityCompleted(String activityId) {
    if (_completedActivityIds.contains(activityId)) {
      _completedActivityIds.remove(activityId);
    } else {
      _completedActivityIds.add(activityId);
    }
    notifyListeners();
  }
}

