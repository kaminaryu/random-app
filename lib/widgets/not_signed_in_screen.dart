import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotSignedInScreen extends StatelessWidget {
  const NotSignedInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 96,
              color: theme.colorScheme.onSurface.withAlpha(102),
            ),
            const SizedBox(height: 24),

            Text(
              'Not yet signed in',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'Sign in to access your profile and settings.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(153),
              ),
            ),
            const SizedBox(height: 32),

            FilledButton.icon(
              onPressed: () async {
                await context.push('/login');
              },
              icon: const Icon(Icons.login),
              label: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
