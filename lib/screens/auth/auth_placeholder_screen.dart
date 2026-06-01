import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/widgets/homepage/section_title.dart';

class AuthPlaceholderScreen extends StatelessWidget {
  const AuthPlaceholderScreen({
    super.key,
    required this.screen,
    required this.formFields,
    required this.onSubmit,
    this.onForgotPassword,
  });

  final String screen;
  final Widget formFields;
  final VoidCallback onSubmit;
  final VoidCallback? onForgotPassword;

  void _onSwitchScreen(BuildContext context) {
    if (screen == "login") {
      context.pushReplacement('/register');
    } else {
      context.pushReplacement('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    IconData welcomeIcon;
    String submitText;
    String changeScreenText;
    String welcomeText;

    if (screen == "login") {
      welcomeIcon = Icons.person_rounded;
      submitText = "Login";
      changeScreenText = "Register instead";
      welcomeText = "Login to i-Bazaar";
    } 
    else {
      welcomeIcon = Icons.person_add_rounded;
      submitText = "Register";
      changeScreenText = "Login instead";
      welcomeText = "Register to i-Bazaar";
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,

        leading: Container(
          margin: const EdgeInsets.only(left: 16.0, top: 16.0),
          padding: const EdgeInsets.all(0.0),

          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withAlpha(127),
            shape: BoxShape.circle,
          ),

          child: IconButton(
            icon: const Icon(Icons.keyboard_arrow_left_rounded),
            onPressed: () => Navigator.of(context).pop(),
            iconSize: 36,
            padding: EdgeInsets.zero,
          ),
        ),
      ),

      body: Container(
        // background gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.surface,
            ]
          )
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                const SizedBox(height: 32),

                // Welcome Icon
                Icon(
                  welcomeIcon,
                  size: 72,
                  color: theme.colorScheme.onSurface.withAlpha(200),
                ),
                const SizedBox(height: 8),

                // Welcome text
                Text(
                  welcomeText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),

                formFields,

                // For password button
                if (screen == "login" && onForgotPassword != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onForgotPassword,
                      child: const Text('Forgot password?'),
                    ),
                  ),

                (screen == "login")
                  ? const SizedBox(height: 8)
                  : const SizedBox(height: 16),

                // Submit button
                FilledButton(
                  onPressed: onSubmit,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(submitText),
                  ),
                ),
                const SizedBox(height: 12),

                // Change Screen button
                OutlinedButton(
                  onPressed: () => _onSwitchScreen(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(changeScreenText),
                  ),
                ),
                const SizedBox(height: 24),

                SectionTitle("Quick Sign-ins"),
                const SizedBox(height: 12),

                // Quick sign ins buttons
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    _socialButton(FontAwesomeIcons.microsoft, () => Navigator.of(context).pop()),
                    _socialButton(FontAwesomeIcons.apple, () {}),
                    _socialButton(FontAwesomeIcons.google, () {}),
                    _socialButton(FontAwesomeIcons.facebook, () {}),
                    _socialButton(FontAwesomeIcons.xTwitter, () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


Widget _socialButton(FaIconData icon, VoidCallback action) {
  return OutlinedButton(
    onPressed: action,
    style: OutlinedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(16),
    ),
    child: FaIcon(icon, size: 28),
  );
}
