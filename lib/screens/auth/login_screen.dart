import 'package:flutter/material.dart';
import 'package:i_bazaar/screens/auth/auth_placeholder_screen.dart';
import 'package:i_bazaar/widgets/auth/auth_password_field.dart';
import 'package:i_bazaar/widgets/auth/auth_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/widgets/auth/snack_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    debugPrint('Login: $email / $password');

    _signIn(email, password);
  }


  Future<void> _signIn(String email, String password) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      _signUpUser(email, password);
    }
    on AuthException catch (e) {
      _handleException(e, messenger);
    }
  }

  void _signUpUser(String email, String password) async {
    final supabase = Supabase.instance.client;

    await supabase.auth.signInWithPassword(
      email: email,
      password: password,
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
      case "invalid_credentials" :
        errorMessage = "Error: Email or Password is incorrect.";
      case "user_not_found" || "user_banned" :
        // even tho this is already handled, but we can still be safe right
        errorMessage = "Error: User is either deleted or banned.";
      case "over_request_rate_limit" :
        errorMessage = "Error: Too many attempts. Try again in a few minutes.";
      default :
        errorMessage = "Error whilst trying to sign up. Please try again.";
    }

    AuthErrorSnackBar.show(messenger, errorMessage, Colors.red);

    debugPrint("!! Log In  Error (Code) !!  ${err.code}");
    debugPrint("!! Log In Error (Msg)  !!  ${err.message}");
  }



  void _onForgotPassword() {
    debugPrint('Forgot password tapped');
  }

  String? _validateEmail(String? v) {
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
            // Email
            AuthTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.person_outline,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: _validateEmail,
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
