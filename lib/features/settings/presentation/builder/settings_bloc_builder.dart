import 'package:flutter/material.dart';
import 'package:two_do/features/authentication/presentation/login/login_screen.dart';
import 'package:two_do/features/settings/presentation/content/settings_content.dart';
import 'package:two_do/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:two_do/features/settings/presentation/cubit/settings_state.dart';
import 'package:two_do/shared/custom_builder.dart';

class SettingsBlocBuilder extends StatelessWidget {
  const SettingsBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocBuilder<SettingsCubit, SettingsState>(
      listenWhen:
          (context, state) =>
              state is SettingsFailure || state is SettingsSignedOut,
      listener: (context, state) {
        if (state is SettingsFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is SettingsSignedOut) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      },
      builder:
          (context, state) => switch (state) {
            _ => const SettingsContent(),
          },
    );
  }
}
