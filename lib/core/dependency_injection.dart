import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:two_do/features/authentication/data/firebase_repository.dart';
import 'package:two_do/features/authentication/domain/auth_repository.dart';
import 'package:two_do/features/authentication/services/google_service.dart';

class DependenciesRoot {
  static bool _initialized = false;

  static void init({
    FirebaseAuth Function()? firebaseAuthBuilder,
    GoogleService Function()? googleServiceBuilder,
    bool force = false,
  }) {
    if (_initialized && !force) return;
    _registerSingleton<AuthRepository>(
      FirebaseAuthRepository(
        firebaseAuth: firebaseAuthBuilder?.call() ?? FirebaseAuth.instance,
        googleService: googleServiceBuilder?.call() ?? GoogleService(),
      ),
      force: force,
    );
    _initialized = true;
  }
  //TODO

  static void _registerSingleton<T>(T instance, {required bool force}) {
    if (Get.isRegistered<T>()) {
      if (!force) return;
      Get.delete<T>(force: true);
    }
    Get.put<T>(instance, permanent: true);
  }

  //You need resetForTests() because tests share process memory and static/global DI state.
  static void resetForTests() {
    if (Get.isRegistered<AuthRepository>()) {
      Get.delete<AuthRepository>(force: true);
    }
    if (Get.isRegistered<GoogleService>()) {
      Get.delete<GoogleService>(force: true);
    }
    _initialized = false;
  }
}
