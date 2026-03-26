import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:two_do/core/result_widget.dart';
import 'package:two_do/features/authentication/domain/model/custom_user.dart';
import 'package:two_do/features/settings/domain/settings_repository.dart';

/// Web implementation of [SettingsRepository].
///
/// Supports user profile operations via Firebase Auth.
/// Photo caching returns null (web has no persistent local file system).
class FirebaseSettingsRepository implements SettingsRepository {
  FirebaseSettingsRepository({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  Future<Result<CustomUser>> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const Failure('No user signed in');
      }
      return Success(
        CustomUser(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        ),
      );
    } catch (e, st) {
      developer.log(
        'Failed to get current user',
        name: 'settings',
        level: 1000,
        error: e,
        stackTrace: st,
      );
      return Failure(
        'Failed to load profile',
        error: e is Exception ? e : Exception(e.toString()),
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> updateDisplayName(String name) async {
    try {
      await _auth.currentUser?.updateDisplayName(name);
      return Success(null);
    } catch (e, st) {
      developer.log(
        'Failed to update display name',
        name: 'settings',
        level: 1000,
        error: e,
        stackTrace: st,
      );
      return Failure(
        'Failed to update name',
        error: e is Exception ? e : Exception(e.toString()),
        stackTrace: st,
      );
    }
  }

  @override
  Future<String?> getLocalProfilePhotoPath() async {
    // Web has no persistent local file system
    return null;
  }

  @override
  Future<String?> cacheLocalProfilePhoto(String sourcePath) async {
    // Web has no persistent local file system
    return null;
  }
}
