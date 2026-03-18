import 'package:flutter/material.dart';
import 'package:focus_app/features/authentication/presentation/login/login_screen.dart';
import 'package:focus_app/features/dashboard/content/dashboard_content.dart';
import 'package:focus_app/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:focus_app/shared/custom_builder.dart';

class DashboardBlocBuilder extends StatelessWidget {
  const DashboardBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocBuilder<DashboardCubit, DashboardState>(
      listenWhen:
          (context, state) =>
              state is DashboardSignedOut || state is DashboardFailure,
      listener: (context, state) {
        if (state is DashboardSignedOut) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
          return;
        }
        if (state is DashboardFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign out failed: ${state.message}')),
          );
        }
      },
      builder: (context, state) => const DashboardContent(),
    );
  }
}
