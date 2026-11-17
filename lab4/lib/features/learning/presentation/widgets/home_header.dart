import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../domain/entities/learning_feed.dart';

/// Header-ul din home: salut, notificare și avatar (design din Lab 3).
class HomeHeaderBar extends StatelessWidget {
  const HomeHeaderBar({super.key, required this.data, this.onNotificationTap});

  final LearningHeader data;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.greeting,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: kInk,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.subtitle,
                style: const TextStyle(fontSize: 13, color: kGrey),
              ),
            ],
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: kInk,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: onNotificationTap,
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 42,
                  height: 42,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: AppSvg(
                      url: data.notificationIconUrl,
                      size: 22,
                      fallback: Icons.notifications_none_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            if (data.hasUnread)
              const Positioned(
                right: 8,
                top: 8,
                child: SizedBox(
                  width: 8,
                  height: 8,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: kOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: AppImage(
            url: data.avatarUrl,
            width: 42,
            height: 42,
          ),
        ),
      ],
    );
  }
}
