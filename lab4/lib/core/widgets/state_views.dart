import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Starea de încărcare, refolosită în feed și în detalii.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message = 'Se încarcă articolele...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          const SizedBox(height: 14),
          Text(message, style: const TextStyle(color: kMuted, fontSize: 13)),
        ],
      ),
    );
  }
}

/// Starea de eroare, cu acțiune de reîncercare.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: kLavender,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: kIndigo,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nu am putut încărca articolele',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                color: kInk,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: kMuted, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reîncearcă'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Starea fără rezultate.
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.title = 'Niciun articol',
    this.message = 'Încearcă alt termen de căutare.',
    this.actionLabel = 'Resetează',
    this.onAction,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: kLavender,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.article_outlined,
                color: kIndigo,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: kInk,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: kMuted, fontSize: 13),
            ),
            if (onAction != null) ...[
              const SizedBox(height: 12),
              TextButton(onPressed: onAction, child: Text(actionLabel)),
            ],
          ],
        ),
      ),
    );
  }
}
