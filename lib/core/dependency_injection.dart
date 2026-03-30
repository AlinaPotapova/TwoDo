import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:two_do/core/connectivity_service.dart';
import 'package:two_do/features/authentication/data/firebase_repository.dart';
import 'package:two_do/features/authentication/domain/auth_repository.dart';
import 'package:two_do/features/authentication/services/google_service.dart';
import 'package:two_do/features/settings/data/firebase_settings_repository.dart'
    if (dart.library.html) 'package:two_do/features/settings/data/firebase_settings_repository_stub.dart';
import 'package:two_do/features/settings/domain/settings_repository.dart';
import 'package:two_do/features/tasks/data/firebase_task_repository.dart';
import 'package:two_do/features/tasks/domain/task_repository.dart';

class DependenciesRoot {
  static bool _initialized = false;

  static void init({
    FirebaseAuth Function()? firebaseAuthBuilder,
    GoogleService Function()? googleServiceBuilder,
    bool force = false,
  }) {
    if (_initialized && !force) return;
    _registerSingleton<ValueNotifier<ThemeMode>>(
      ValueNotifier(ThemeMode.system),
      force: force,
    );
    _registerSingleton<AuthRepository>(
      FirebaseAuthRepository(
        firebaseAuth: firebaseAuthBuilder?.call() ?? FirebaseAuth.instance,
        googleService: googleServiceBuilder?.call() ?? GoogleService(),
      ),
      force: force,
    );
    _registerSingleton<SettingsRepository>(
      FirebaseSettingsRepository(),
      force: force,
    );
    _registerSingleton<ConnectivityService>(
      ConnectivityService(),
      force: force,
    );
    _registerSingleton<TaskRepository>(
      FirebaseTaskRepository(auth: firebaseAuthBuilder?.call() ?? FirebaseAuth.instance),
      force: force,
    );
    _initialized = true;
  }

  static void _registerSingleton<T>(T instance, {required bool force}) {
    if (Get.isRegistered<T>()) {
      if (!force) return;
      Get.delete<T>(force: true);
    }
    Get.put<T>(instance, permanent: true);
  }

  static void resetForTests() {
    if (Get.isRegistered<AuthRepository>()) {
      Get.delete<AuthRepository>(force: true);
    }
    if (Get.isRegistered<GoogleService>()) {
      Get.delete<GoogleService>(force: true);
    }
    if (Get.isRegistered<SettingsRepository>()) {
      Get.delete<SettingsRepository>(force: true);
    }
    if (Get.isRegistered<ConnectivityService>()) {
      Get.delete<ConnectivityService>(force: true);
    }
    if (Get.isRegistered<TaskRepository>()) {
      Get.delete<TaskRepository>(force: true);
    }
    if (Get.isRegistered<ValueNotifier<ThemeMode>>()) {
      Get.delete<ValueNotifier<ThemeMode>>(force: true);
    }
    _initialized = false;
  }
}
