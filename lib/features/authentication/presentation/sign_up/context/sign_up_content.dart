import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_do/features/authentication/presentation/login/login_screen.dart';
import 'package:two_do/features/authentication/presentation/sign_up/cubit/sign_up_cubit.dart';
import 'package:two_do/shared/auth_widgets.dart';

class SignUpContent extends StatefulWidget {
  const SignUpContent({super.key});

  @override
  State<SignUpContent> createState() => _SignUpContentState();
}

class _SignUpContentState extends State<SignUpContent> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1621),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  final navigator = Navigator.of(context);
                  if (navigator.canPop()) {
                    navigator.pop();
                  } else {
                    navigator.pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
              ),

              const SizedBox(height: 12),

              // Title
              const Center(
                child: Text(
                  "Create Your Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Name
              AuthLabeledField(
                label: "Your Name",
                labelStyle: const TextStyle(color: Colors.white70),
                child: AuthTextField(
                  controller: _nameController,
                  hintText: "e.g., Alex",
                  fillColor: const Color(0xFF2A2A2A),
                  hintColor: Colors.grey,
                  textStyle: const TextStyle(color: Colors.white),
                  borderRadius: 14,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Email
              AuthLabeledField(
                label: "Email",
                labelStyle: const TextStyle(color: Colors.white70),
                child: AuthTextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: "you@example.com",
                  fillColor: const Color(0xFF2A2A2A),
                  hintColor: Colors.grey,
                  textStyle: const TextStyle(color: Colors.white),
                  borderRadius: 14,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password
              AuthLabeledField(
                label: "Password",
                labelStyle: const TextStyle(color: Colors.white70),
                child: AuthTextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  hintText: "Enter your password",
                  fillColor: const Color(0xFF2A2A2A),
                  hintColor: Colors.grey,
                  textStyle: const TextStyle(color: Colors.white),
                  borderRadius: 14,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Confirm Password
              AuthLabeledField(
                label: "Confirm Password",
                labelStyle: const TextStyle(color: Colors.white70),
                child: AuthTextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  hintText: "Confirm your password",
                  fillColor: const Color(0xFF2A2A2A),
                  hintColor: Colors.grey,
                  textStyle: const TextStyle(color: Colors.white),
                  borderRadius: 14,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),

              const Spacer(),

              // Sign Up button
              AuthPrimaryButton(
                text: "Sign Up",
                height: 54,
                verticalPadding: 0,
                backgroundColor: const Color(0xFF1E6EF4),
                borderRadius: 14,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                onPressed: () {
                  final name = _nameController.text.trim();
                  final email = _emailController.text.trim();
                  final password = _passwordController.text;
                  final confirmPassword = _confirmPasswordController.text;

                  if (name.isEmpty ||
                      email.isEmpty ||
                      password.isEmpty ||
                      confirmPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields.'),
                      ),
                    );
                    return;
                  }

                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match.')),
                    );
                    return;
                  }

                  context.read<SignUpCubit>().signUp(email, password);
                },
              ),

              const SizedBox(height: 16),

              // Login link
              Center(
                child: TextButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.white70),
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(
                            color: Color(0xFF1E6EF4),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
