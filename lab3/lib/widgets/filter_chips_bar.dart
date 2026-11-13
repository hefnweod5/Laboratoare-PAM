import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class FilterEntry {
  final String id;
  final String label;

  const FilterEntry(this.id, this.label);
}

/// Bară orizontală de chips-uri pentru filtrare, reutilizabilă.
class FilterChipsBar extends StatelessWidget {
  final List<FilterEntry> filters;
  final String selectedId;
  final ValueChanged<String> onSelected;

  const FilterChipsBar({
    super.key,
    required this.filters,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = filter.id == selectedId;
          return ChoiceChip(
            label: Text(filter.label),
            selected: selected,
            onSelected: (_) => onSelected(filter.id),
            showCheckmark: false,
            labelStyle: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : kInkSoft,
            ),
            selectedColor: kInk,
            backgroundColor: Colors.white,
            side: BorderSide(
              color: selected ? kInk : const Color(0xFFE4E4E9),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          );
        },
      ),
    );
  }
}
