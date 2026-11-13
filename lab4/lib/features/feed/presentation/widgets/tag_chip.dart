import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Etichetă compactă pentru subiectele unui articol.
class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.label, this.onDark = false});

  final String label;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: onDark ? Colors.white.withValues(alpha: 0.16) : kLavender,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: onDark ? Colors.white : kIndigo,
        ),
      ),
    );
  }
}
