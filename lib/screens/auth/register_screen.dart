import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:i_bazaar/screens/auth/auth_placeholder_screen.dart';
import 'package:i_bazaar/widgets/auth/auth_password_field.dart';
import 'package:i_bazaar/widgets/auth/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    debugPrint('Register: $name / $email / $password / $confirmPassword');
  }

  String? _validateRequired(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'Required';
    if (!EmailValidator.validate(v)) return 'Invalid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.length < 6) return 'At least 6 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Required';
    if (v != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AuthPlaceholderScreen(
      screen: "register",
      onSubmit: _onSubmit,
      formFields: Form(
        key: _formKey,
        child: Column(
          children: [
            // Name
            AuthTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person_outline,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: _validateRequired,
            ),
            const SizedBox(height: 16),

            // Email
            AuthTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              hintText: 'example@gmail.com',
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),

            // Password
            AuthPasswordField(
              controller: _passwordController,
              label: 'Password',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: _validatePassword,
            ),
            const SizedBox(height: 16),

            // Confirm Password
            AuthPasswordField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _onSubmit(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: _validateConfirm,
            ),
          ],
        ),
      ),
    );
  }
}
