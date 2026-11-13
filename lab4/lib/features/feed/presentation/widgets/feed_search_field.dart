import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Câmpul de căutare, cu buton de golire afișat doar când există text.
class FeedSearchField extends StatelessWidget {
  const FeedSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          style: const TextStyle(fontSize: 13.5, color: kInk),
          decoration: InputDecoration(
            hintText: 'Caută un articol...',
            hintStyle: const TextStyle(color: kMutedLight, fontSize: 13.5),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: kMuted,
              size: 21,
            ),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    onPressed: onClear,
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: kMuted,
                    ),
                  ),
            filled: true,
            fillColor: kCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: kIndigo, width: 1.4),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
        );
      },
    );
  }
}
