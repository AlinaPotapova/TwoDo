import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:two_do/features/authentication/domain/auth_repository.dart';
import 'package:two_do/features/settings/domain/settings_repository.dart';
import 'package:two_do/features/settings/presentation/content/settings_content.dart';
import 'package:two_do/features/settings/presentation/cubit/settings_cubit.dart';

/// Entry point for the Settings feature.
///
/// Provides [SettingsCubit] and immediately triggers profile loading.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(
        settingsRepository: Get.find<SettingsRepository>(),
        authRepository: Get.find<AuthRepository>(),
        themeController: Get.find<ValueNotifier<ThemeMode>>(),
      )..load(),
      child: const SettingsContent(),
    );
  }
}
