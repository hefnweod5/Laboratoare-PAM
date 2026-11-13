import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/course_models.dart' as models;
import 'app_image.dart';

/// Header-ul din homePage: salut, subtitlu, notificare și avatar.
class HomeHeaderBar extends StatelessWidget {
  final models.HomeHeader data;

  const HomeHeaderBar({super.key, required this.data});

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
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: kInk,
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(10),
              child: AppSvg(
                url: data.notificationIconUrl,
                size: 22,
                fallback: Icons.notifications_none_rounded,
              ),
            ),
            if (data.hasUnread)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: kOrange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 10),
        AppImage(
          url: data.avatarUrl,
          width: 42,
          height: 42,
          radius: BorderRadius.circular(14),
        ),
      ],
    );
  }
}
