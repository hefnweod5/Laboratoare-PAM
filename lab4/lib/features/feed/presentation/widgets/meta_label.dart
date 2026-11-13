import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Formatare scurtă pentru numere mari (1250 -> 1.3k).
String formatCompact(int value) {
  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(1)}k';
  }
  return '$value';
}

/// Icoană + text, folosită pentru metadatele articolelor.
class MetaLabel extends StatelessWidget {
  const MetaLabel({
    super.key,
    required this.icon,
    required this.text,
    this.onDark = false,
  });

  final IconData icon;
  final String text;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 13,
          color: onDark ? Colors.white.withValues(alpha: 0.7) : kMuted,
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: onDark ? Colors.white.withValues(alpha: 0.7) : kMuted,
          ),
        ),
      ],
    );
  }
}
