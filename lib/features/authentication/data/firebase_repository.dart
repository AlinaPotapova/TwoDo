import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:focus_app/core/result_widget.dart';
import 'package:focus_app/features/authentication/domain/auth_repository.dart';
import 'package:focus_app/features/authentication/domain/model/custom_user.dart';
import 'package:focus_app/features/authentication/services/google_service.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleService? googleSignIn,
    required GoogleService googleService,
  }) : _auth = firebaseAuth ?? FirebaseAuth.instance,
       _googleService = googleSignIn ?? GoogleService();

  final FirebaseAuth _auth;
  final GoogleService _googleService;

  @override
  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<Result<void>> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      //TODO
      return Success<void>(null);
    } catch (e, st) {
      return Failure<void>(
        'Unknown error',
        error: e is Exception ? e : Exception(e.toString()),
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<CustomUser>> loginWithGoogle() async {
    try {
      final userCredential = await _googleService.signInWithGoogle();

      return Success(
        CustomUser(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? '',
          email: userCredential.user!.email ?? '',
        ),
      );
    } catch (e, st) {
      return Failure<CustomUser>(
        'Unknown error',
        error: e is Exception ? e : Exception(e.toString()),
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<Result<void>> forgetPassword({required String email}) async {
    try {
      debugPrint('Password reset email sent to $email');
      await _auth.sendPasswordResetEmail(email: email);
      return Success<void>(null);
    } catch (e, st) {
      debugPrint('Failed to send password reset email: $e');
      return Failure<void>(
        'Failed to send password reset email',
        error: e is Exception ? e : Exception(e.toString()),
        stackTrace: st,
      );
    }
  }
}
