import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';

/// Iconiță SVG livrată de API (Iconify), cu fallback Material.
class AppSvg extends StatelessWidget {
  const AppSvg({
    super.key,
    required this.url,
    this.size = 22,
    this.fallback = Icons.circle_outlined,
    this.color,
  });

  final String url;
  final double size;
  final IconData fallback;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Icon(fallback, size: size, color: color ?? kGrey);
    }

    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.network(
        url,
        width: size,
        height: size,
        placeholderBuilder: (_) => SizedBox(width: size, height: size),
        errorBuilder: (_, _, _) => Icon(
          fallback,
          size: size * 0.9,
          color: color ?? kGrey,
        ),
      ),
    );
  }
}
