import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/services/prefs_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ThemeMode _selectedTheme = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: PrefsService.loginStatusNotifier,
      builder: (context, loggedIn, child) {
        if (loggedIn) {
          return _buildSignedIn(context);
        }
        return _buildNotSignedIn(context);
      },
    );
  }

  Widget _buildNotSignedIn(BuildContext context) {
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
                if (mounted) setState(() {});
              },
              icon: const Icon(Icons.login),
              label: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignedIn(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHero(theme),
          const SizedBox(height: 28),
          _buildThemeCard(theme),
          const SizedBox(height: 12),
          _buildAdspaceCard(theme),
          const SizedBox(height: 12),
          _buildInfoCard(theme),
          const SizedBox(height: 12),
          _buildLogoutCard(theme),
        ],
      ),
    );
  }

  Widget _buildHero(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            _initials('John Doe'),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'john.doe@example.com',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(153),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard(ThemeData theme) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Theme', style: theme.textTheme.titleSmall),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _themeOption(ThemeMode.light, Icons.light_mode, theme)),
                const SizedBox(width: 8),
                Expanded(child: _themeOption(ThemeMode.dark, Icons.dark_mode, theme)),
                const SizedBox(width: 8),
                Expanded(child: _themeOption(ThemeMode.system, Icons.settings_brightness, theme)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdspaceCard(ThemeData theme) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: const Icon(Icons.campaign),
        title: const Text('Buy Adspace'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/adspace'),
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showComingSoon(context, 'Privacy Policy'),
          ),
          const Divider(height: 1, indent: 56),

          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showComingSoon(context, 'Terms of Service'),
          ),
          const Divider(height: 1, indent: 56),

          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help Center'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showComingSoon(context, 'Help Center'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutCard(ThemeData theme) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              PrefsService.setLoggedIn(false);
              // reset everything on screen
              setState(() { });
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  Widget _themeOption(ThemeMode mode, IconData icon, ThemeData theme) {
    final selected = _selectedTheme == mode;
    return Material(
      color: selected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _selectedTheme = mode),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Icon(
            icon,
            color: selected
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurface.withAlpha(128),
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ').where((s) => s.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  void _showComingSoon(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            const Text('Coming soon.'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
