import 'package:focus_app/core/result_widget.dart';
import 'package:focus_app/features/authentication/domain/model/custom_user.dart';

abstract class AuthRepository {
  Future<void> signUp(String email, String password);
  Future<Result<void>> signIn(String email, String password);
  Future<void> signOut();
  Future<Result<void>> forgetPassword({required String email});

  Future<Result<CustomUser>> loginWithGoogle();
}
