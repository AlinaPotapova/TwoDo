import 'package:two_do/core/result_widget.dart';
import 'package:two_do/features/authentication/domain/model/custom_user.dart';

/// Repository for user profile and settings operations.
abstract class SettingsRepository {
  /// Returns the currently signed-in user.
  Future<Result<CustomUser>> getCurrentUser();

  /// Updates the display name of the current user.
  Future<Result<void>> updateDisplayName(String name);

  /// Returns the cached local profile photo path, if any.
  Future<String?> getLocalProfilePhotoPath();

  /// Copies the photo at [sourcePath] into app documents storage and caches
  /// the local path for offline access.
  Future<String?> cacheLocalProfilePhoto(String sourcePath);

}
