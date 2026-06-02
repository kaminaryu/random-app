import 'package:flutter/material.dart';
import 'package:i_bazaar/screens/auth/auth_placeholder_screen.dart';
import 'package:i_bazaar/services/prefs_service.dart';
import 'package:i_bazaar/widgets/auth/auth_password_field.dart';
import 'package:i_bazaar/widgets/auth/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    debugPrint('Login: $username / $password');

    PrefsService.setLoggedIn(true);
    Navigator.of(context).pop();
  }

  void _onForgotPassword() {
    debugPrint('Forgot password tapped');
  }

  String? _validateUsername(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.length < 6) return 'At least 6 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AuthPlaceholderScreen(
      screen: "login",
      onSubmit: _onSubmit,
      onForgotPassword: _onForgotPassword,
      formFields: Form(
        key: _formKey,
        child: Column(
          children: [
            // Username
            AuthTextField(
              controller: _usernameController,
              label: 'Username or Email',
              icon: Icons.person_outline,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: _validateUsername,
            ),
            const SizedBox(height: 16),

            // Password
            AuthPasswordField(
              controller: _passwordController,
              label: 'Password',
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _onSubmit(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: _validatePassword,
            ),
          ],
        ),
      ),
    );
  }
}
