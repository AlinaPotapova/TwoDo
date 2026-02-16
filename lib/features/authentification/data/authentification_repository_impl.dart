import 'package:firebase_auth/firebase_auth.dart';
import 'package:focus_app/core/result_widget.dart';
import 'package:focus_app/features/authentification/domain/auth_repository.dart';
import 'package:focus_app/features/authentification/services/auth_service.dart';
import 'package:focus_app/features/authentification/services/google_service.dart';

/// Simple auth repository delegating to [AuthService].
class AuthentificationRepositoryImpl implements AuthRepository {
  AuthentificationRepositoryImpl({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;
  final GoogleService _googleService = GoogleService();

  @override
  Future<void> signUp(String email, String password) async {
    await _authService.createAccount(email: email, password: password);
  }

  @override
  Future<Result<void>> signIn(String email, String password) async {
    try {
      await _authService.signIn(email: email, password: password);
      return Success<void>(null);
    } on FirebaseAuthException catch (e, st) {
      return Failure<UserCredential>(
        e.message ?? 'Auth error',
        error: e,
        stackTrace: st,
      );
    } catch (e, st) {
      return Failure<UserCredential>(
        'Unknown error',
        error: e is Exception ? e : Exception(e.toString()),
        stackTrace: st,
      );
    }
  }

  Future<Result<UserCredential>> signInWithGoogle() async {
    try {
      final userCredential = await _googleService.signInWithGoogle();
      return Success(userCredential);
    } catch (e, st) {
      return Failure<UserCredential>(
        'Unknown error',
        error: e is Exception ? e : Exception(e.toString()),
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Future<void> forgetPassword(String email) {
    _authService.forgetPassword(email: email);
    throw UnimplementedError();
  }
}
