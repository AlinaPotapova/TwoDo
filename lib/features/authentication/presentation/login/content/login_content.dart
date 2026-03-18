import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_app/features/authentication/presentation/login/cubit/cubit/login_cubit.dart';
import 'package:focus_app/features/authentication/presentation/sign_up/sign_up_screen.dart';
import 'package:focus_app/shared/auth_widgets.dart';
import 'package:focus_app/shared/circular_indicator.dart';

class LoginContent extends StatefulWidget {
  const LoginContent({super.key});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return Scaffold(
          backgroundColor: const Color(0xFF111827), // Dark background
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _LoginHeader(),
                    const SizedBox(height: 24),
                    const Text(
                      "Log in to continue building your focus.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    AuthLabeledField(
                      label: 'Email',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                      child: AuthTextField(
                        controller: _emailController,
                        hintText: 'Enter your email',
                        fillColor: Color(0xFF1F2937),
                        textStyle: TextStyle(color: Colors.white),
                        hintColor: Colors.white54,
                        prefixIcon: Icons.email_outlined,
                        prefixIconColor: Colors.white70,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                      ),
                    ),
                    const SizedBox(height: 24),
                    AuthLabeledField(
                      label: 'Password',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                      child: AuthTextField(
                        controller: _passwordController,
                        obscureText: true,
                        hintText: 'Enter your password',
                        fillColor: Color(0xFF1F2937),
                        textStyle: TextStyle(color: Colors.white),
                        hintColor: Colors.white54,
                        prefixIcon: Icons.lock_outline,
                        prefixIconColor: Colors.white70,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _ForgotPasswordButton(
                      onPressed:
                          isLoading
                              ? () {
                                CircularIndicator(progress: 0.5);
                              }
                              : () {
                                context.read<LoginCubit>().forgetPassword(
                                  "potapovaalina935@gmail.com",
                                );
                              },
                    ),
                    const SizedBox(height: 16),
                    AuthPrimaryButton(
                      text: 'Log In',
                      isLoading: isLoading,
                      backgroundColor: const Color.fromARGB(255, 154, 174, 216),
                      textStyle: const TextStyle(fontSize: 18),
                      onPressed: () {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text;

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter email and password.'),
                            ),
                          );
                          return;
                        }

                        context.read<LoginCubit>().login(email, password);
                      },
                    ),
                    const SizedBox(height: 20),
                    const _AuthDivider(),
                    const SizedBox(height: 20),
                    AuthPrimaryButton(
                      text: 'Continue with Google',
                      isLoading: isLoading,
                      backgroundColor: const Color(0xFF1F2937),
                      textStyle: const TextStyle(fontSize: 18),
                      onPressed: () {
                        context
                            .read<LoginCubit>()
                            .loginWithGoogle()
                            .then((_) {
                              // Handle successful Google login, e.g., navigate to dashboard
                            })
                            .catchError((error) {
                              // Handle error during Google login
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Google login failed: $error'),
                                ),
                              );
                            });
                      },
                    ),
                    const SizedBox(height: 24),
                    _SignUpLink(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 64),
        Icon(Icons.favorite_border, color: Colors.blue.shade400, size: 60),
        const SizedBox(height: 24),
        const Text(
          "Welcome Back",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Let's get organized, together.",
          style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.6)),
        ),
      ],
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onPressed,
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.blueAccent),
        ),
      ),
    );
  }
}

class _SignUpLink extends StatelessWidget {
  const _SignUpLink({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Color.fromARGB(255, 107, 111, 222)),
          ),
        ),
      ],
    );
  }
}

class _AuthDivider extends StatelessWidget {
  const _AuthDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Divider(color: Colors.white24, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "OR",
            style: TextStyle(color: Colors.white54, letterSpacing: 1),
          ),
        ),
        Expanded(child: Divider(color: Colors.white24, thickness: 1)),
      ],
    );
  }
}
