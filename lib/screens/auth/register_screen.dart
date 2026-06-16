import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/screens/auth/auth_placeholder_screen.dart';
import 'package:i_bazaar/widgets/auth/auth_password_field.dart';
import 'package:i_bazaar/widgets/auth/auth_text_field.dart';
import 'package:i_bazaar/widgets/auth/snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    debugPrint('User Register: $name / $email / $password / $confirmPassword');

    _signUp(name, email, password);
  }


  Future<void> _signUp(String name, String email, String password) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      _signUpUser(name, email, password);
    }
    on AuthException catch (e) {
      _handleException(e, messenger);
    }
  }


  void _signUpUser(String name, String email, String password) async {
    final supabase = Supabase.instance.client;

    await supabase.auth.signUp(
      email: email,
      password: password,

      data: {
        "username": name,
      }
    );

    // check to see if the screen / widget is still moutned
    if (mounted) {
      context.pop();
    }
  }


  void _handleException(AuthException err, ScaffoldMessengerState messenger) {
    // TODO: add proper err message
    String errorMessage = "";

    switch (err.code) {
      case "user_already_exists" || "email_exists" || "phone_exists" :
        errorMessage = "Error: User is already registered";
      case "weak_password" :
        // even tho this is already handled, but we can still be safe right
        errorMessage = "Error: Password is too short!";
      default :
        errorMessage = "Error whilst trying to sign up. Please try again.";
    }

    AuthErrorSnackBar.show(messenger, errorMessage, Colors.red);

    debugPrint("!! Sign Up Error (Code) !!  ${err.code}");
    debugPrint("!! Sign Up Error (Msg)  !!  ${err.message}");
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
