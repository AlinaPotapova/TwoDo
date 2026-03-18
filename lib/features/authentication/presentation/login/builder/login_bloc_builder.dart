import 'package:flutter/material.dart';
import 'package:focus_app/features/dashboard/dashboard_screen.dart';
import 'package:focus_app/features/authentication/presentation/login/content/login_content.dart';
import 'package:focus_app/features/authentication/presentation/login/cubit/cubit/login_cubit.dart';
import 'package:focus_app/shared/custom_builder.dart';

class LoginBlocBuilder extends StatelessWidget {
  const LoginBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocBuilder<LoginCubit, LoginState>(
      listenWhen:
          (context, state) => state is LoginSuccess || state is LoginFailure,
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is LoginSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      },
      builder:
          (context, state) => switch (state) {
            _ => const LoginContent(),
          },
    );
  }
}
