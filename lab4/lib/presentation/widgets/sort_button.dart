import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class MenuEntry<T> {
  final T value;
  final String label;

  const MenuEntry(this.value, this.label);
}

/// Buton de sortare cu meniu, reutilizabil pentru cursuri și lecții.
class SortMenu<T> extends StatelessWidget {
  const SortMenu({
    super.key,
    required this.value,
    required this.entries,
    required this.onSelected,
  });

  final T value;
  final List<MenuEntry<T>> entries;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      initialValue: value,
      onSelected: onSelected,
      tooltip: 'Sortează',
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (context) => entries
          .map(
            (entry) => PopupMenuItem<T>(
              value: entry.value,
              child: Row(
                children: [
                  Icon(
                    entry.value == value
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 18,
                    color: entry.value == value ? kOrange : kGrey,
                  ),
                  const SizedBox(width: 10),
                  Text(entry.label, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFE4E4E9)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_vert_rounded, size: 18, color: kInkSoft),
            SizedBox(width: 6),
            Text(
              'Sortează',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: kInkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
