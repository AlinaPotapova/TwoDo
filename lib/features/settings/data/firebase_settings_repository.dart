import 'dart:developer' as developer;
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:two_do/core/result_widget.dart';
import 'package:two_do/features/authentication/domain/model/custom_user.dart';
import 'package:two_do/features/settings/domain/settings_repository.dart';

/// Firebase implementation of [SettingsRepository].
/// Images are stored locally in app documents directory.
class FirebaseSettingsRepository implements SettingsRepository {
  FirebaseSettingsRepository({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  static const String _photoDir = 'profile_photos';

  Future<Directory> _getPhotoDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final photoDir = Directory('${directory.path}/$_photoDir');
    if (!await photoDir.exists()) {
      await photoDir.create(recursive: true);
    }
    return photoDir;
  }

  @override
  Future<String?> getLocalProfilePhotoPath() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final dir = await _getPhotoDirectory();
    final photoPath = '${dir.path}/$uid.jpg';
    final file = File(photoPath);

    // Return path only if file exists
    if (await file.exists()) {
      return photoPath;
    }
    return null;
  }

  @override
  Future<String?> cacheLocalProfilePhoto(String sourcePath) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return null;
      final dir = await _getPhotoDirectory();
      final targetFile = File('${dir.path}/$uid.jpg');
      await File(sourcePath).copy(targetFile.path);
      return targetFile.path;
    } catch (e, st) {
      developer.log(
        'Failed to cache local photo',
        name: 'settings',
        level: 1000,
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

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
}
