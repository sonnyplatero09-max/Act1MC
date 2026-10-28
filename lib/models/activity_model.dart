import 'package:flutter/material.dart';

/// Represents an activity/laboratory module in the portfolio app.
class ActivityItem {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color accentColor;
  final String routeName;
  final List<String> tags;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.routeName,
    required this.tags,
  });
}

