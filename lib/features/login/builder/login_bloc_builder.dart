import 'package:flutter/material.dart';
import 'package:focus_app/features/dashboard/dashboard.dart';
import 'package:focus_app/features/login/content/login_content.dart';
import 'package:focus_app/features/login/content/login_error_content.dart';
import 'package:focus_app/features/login/cubit/cubit/login_cubit.dart';
import 'package:focus_app/core/custom_builder.dart';

class LoginBlocBuilder extends StatelessWidget {
  const LoginBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocBuilder<LoginCubit, LoginState>(
      listenWhen: (context, state) => state is LoginSuccess,
      listener: (context, state) => {
        if (state is LoginSuccess)
          {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            ),
          },
      },
      builder: (context, state) => switch (state) {
        LoginFailure() => LoginErrorContent(message: state.errorMessage),
        LoginLoading() => const Center(child: CircularProgressIndicator()),
        _ => const LoginContent(),
      },
    );
  }
}
