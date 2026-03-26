import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_do/core/image_provider/local_file_image_io.dart';
import 'package:two_do/core/result_widget.dart';
import 'package:two_do/features/authentication/domain/auth_repository.dart';
import 'package:two_do/features/authentication/domain/model/custom_user.dart';
import 'package:two_do/features/settings/domain/settings_repository.dart';
import 'package:two_do/features/settings/presentation/cubit/settings_state.dart';

/// Manages state for the Settings screen.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required SettingsRepository settingsRepository,
    required AuthRepository authRepository,
    required ValueNotifier<ThemeMode> themeController,
  }) : _settings = settingsRepository,
       _auth = authRepository,
       _themeController = themeController,
       super(SettingsInitial());

  final SettingsRepository _settings;
  final AuthRepository _auth;
  final ValueNotifier<ThemeMode> _themeController;
  CustomUser? _user;
  String? _localPhotoPath;

  /// Loads the current user profile.
  Future<void> load() async {
    emit(SettingsLoading());
    _localPhotoPath = await _settings.getLocalProfilePhotoPath();
    final result = await _settings.getCurrentUser();
    switch (result) {
      case Success(:final data):
        _user = data;
        emit(
          SettingsLoaded(
            user: data,
            themeMode: _themeController.value,
            localPhotoPath: _localPhotoPath,
          ),
        );
      case Failure(:final message):
        emit(
          SettingsFailure(message: message, localPhotoPath: _localPhotoPath),
        );
    }
  }

  /// Updates the app theme and notifies the [ValueNotifier].
  void setTheme(ThemeMode mode) {
    _themeController.value = mode;
    if (_user case final user?) {
      emit(
        SettingsLoaded(
          user: user,
          themeMode: mode,
          localPhotoPath: _localPhotoPath,
        ),
      );
    }
  }

  /// Updates the display name and reloads the profile.
  Future<void> updateDisplayName(String name) async {
    final user = _user;
    if (user == null) return;
    emit(
      SettingsUpdating(
        user: user,
        themeMode: _themeController.value,
        localPhotoPath: _localPhotoPath,
      ),
    );
    final result = await _settings.updateDisplayName(name);
    switch (result) {
      case Success():
        await _reloadUser();
      case Failure(:final message):
        emit(
          SettingsFailure(
            message: message,
            user: user,
            localPhotoPath: _localPhotoPath,
          ),
        );
    }
  }

  /// Saves a profile photo locally.
  Future<void> uploadPhoto(String filePath) async {
    final user = _user;
    if (user == null) return;
    emit(
      SettingsUploading(
        user: user,
        themeMode: _themeController.value,
        localPhotoPath: _localPhotoPath,
      ),
    );
    final cachedPath = await _settings.cacheLocalProfilePhoto(filePath);
    if (cachedPath != null) {
      _localPhotoPath = cachedPath;
      // Evict the old cached image so the new one loads from disk
      await evictLocalFileImage(cachedPath);
      emit(
        SettingsUpdateSuccess(
          user: user,
          themeMode: _themeController.value,
          localPhotoPath: _localPhotoPath,
        ),
      );
    } else {
      emit(
        SettingsFailure(
          message: 'Failed to save photo',
          user: user,
          localPhotoPath: _localPhotoPath,
        ),
      );
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
    emit(SettingsSignedOut());
  }

  Future<void> _reloadUser() async {
    _localPhotoPath = await _settings.getLocalProfilePhotoPath();
    final result = await _settings.getCurrentUser();
    switch (result) {
      case Success(:final data):
        _user = data;
        emit(
          SettingsUpdateSuccess(
            user: data,
            themeMode: _themeController.value,
            localPhotoPath: _localPhotoPath,
          ),
        );
      case Failure(:final message):
        emit(
          SettingsFailure(
            message: message,
            user: _user,
            localPhotoPath: _localPhotoPath,
          ),
        );
    }
  }
}
