import 'package:bloc/bloc.dart';
import 'package:two_do/core/result_widget.dart';
import 'package:two_do/features/authentication/domain/auth_repository.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepo) : super(LoginInitial());

  //TODO: refactor
  final AuthRepository _authRepo;

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    await Future<void>.delayed(Duration.zero);
    try {
      final result = await _authRepo.signIn(email, password);
      switch (result) {
        case Success():
          emit(LoginSuccess());
        case Failure(:final message):
          emit(LoginFailure(message));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    await Future<void>.delayed(Duration.zero);
    final result = await _authRepo.loginWithGoogle();
    switch (result) {
      case Success():
        emit(LoginSuccess());
      case Failure(:final message):
        emit(LoginFailure(message));
    }
  }

  Future<void> logout() async {
    emit(LoginLoading());
    try {
      await _authRepo.signOut();
      emit(LoginInitial());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> forgetPassword(String email) async {
    try {
      emit(LoginLoading());
      final result = await _authRepo.forgetPassword(email: email);
      switch (result) {
        case Success():
          emit(LoginInitial());
        case Failure(:final message):
          emit(LoginFailure(message));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
