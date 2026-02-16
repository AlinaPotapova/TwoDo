import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_app/features/authentification/services/auth_service.dart';
import 'package:focus_app/features/authentification/data/authentification_repository_impl.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<Sign_upState> {
  SignUpCubit({AuthentificationRepositoryImpl? authentificationRepository})
    : _authRepo =
          authentificationRepository ??
          AuthentificationRepositoryImpl(authService: AuthService()),
      super(SignUpInitial());

  final AuthentificationRepositoryImpl _authRepo;

  Future<void> signUp(String email, String password) async {
    emit(SignUpLoading());
    try {
      await _authRepo.signUp(email, password);
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }
}
