import 'package:flutter/material.dart';
import 'package:two_do/features/authentication/domain/model/custom_user.dart';

sealed class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  SettingsLoaded({
    required this.user,
    required this.themeMode,
    this.localPhotoPath,
  });
  final CustomUser user;
  final ThemeMode themeMode;
  final String? localPhotoPath;
}

/// Photo upload is in progress; existing user data is still shown.
class SettingsUploading extends SettingsState {
  SettingsUploading({
    required this.user,
    required this.themeMode,
    this.localPhotoPath,
  });
  final CustomUser user;
  final ThemeMode themeMode;
  final String? localPhotoPath;
}

class SettingsUpdateSuccess extends SettingsState {
  SettingsUpdateSuccess({
    required this.user,
    required this.themeMode,
    this.localPhotoPath,
  });
  final CustomUser user;
  final ThemeMode themeMode;
  final String? localPhotoPath;
}

class SettingsFailure extends SettingsState {
  SettingsFailure({
    required this.message,
    this.user,
    this.themeMode,
    this.localPhotoPath,
  });
  final String message;
  final CustomUser? user;
  final ThemeMode? themeMode;
  final String? localPhotoPath;
}

class SettingsSignedOut extends SettingsState {}
