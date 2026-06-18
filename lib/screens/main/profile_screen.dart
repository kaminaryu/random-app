import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/widgets/profile/theme_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        bool loggedIn = false;

        // check if the user is logged in
        if (snapshot.connectionState == ConnectionState.waiting) {
          // if connection still not resolve, put loading screen
          return _buildLoading(context);
        }
        else {
          // if finished loading, check if user sess exist
          loggedIn = (snapshot.data?.session != null);
        }

      // hide login button if user if loggedIN
        if (loggedIn) {
          return _buildSignedIn(context);
        }
        return _buildNotSignedIn(context);
      }
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Center(child: CircularProgressIndicator());
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

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(theme),
            const SizedBox(height: 28),
            ThemeCard(theme),
            const SizedBox(height: 12),
            _buildAdspaceCard(theme),
            const SizedBox(height: 12),
            _buildInfoCard(theme),
            const SizedBox(height: 12),
            _buildLogoutCard(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            Icons.person,
            color: theme.colorScheme.onPrimaryContainer,
            size: 36,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                supabase.auth.currentUser?.userMetadata?["username"] ?? "John Doe",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                supabase.auth.currentUser?.email ?? "example@mail.com",
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
            onTap: () => {},
          ),
          const Divider(height: 1, indent: 56),

          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => {},
          ),
          const Divider(height: 1, indent: 56),

          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help Center'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => {},
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
            onPressed: _logout,
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

  void _logout() {
    supabase.auth.signOut();
    // reset everything on screen
    setState(() { });
  }

  
}
