import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/app_colors.dart';

/// Imagine de rețea cu placeholder și fallback.
class AppImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? radius;

  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _placeholder(
          child: const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stack) => _placeholder(
        child: const Icon(Icons.image_not_supported_outlined, color: kGrey),
      ),
    );

    if (radius == null) return image;
    return ClipRRect(borderRadius: radius!, child: image);
  }

  Widget _placeholder({required Widget child}) => Container(
        width: width,
        height: height,
        color: kFieldFill,
        alignment: Alignment.center,
        child: child,
      );
}

/// Iconiță SVG de rețea (iconify), cu fallback pe o iconiță Material.
class AppSvg extends StatelessWidget {
  final String url;
  final double size;
  final IconData fallback;

  const AppSvg({
    super.key,
    required this.url,
    this.size = 22,
    this.fallback = Icons.circle_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.network(
        url,
        width: size,
        height: size,
        placeholderBuilder: (_) => Icon(fallback, size: size * 0.8, color: kGrey),
      ),
    );
  }
}
