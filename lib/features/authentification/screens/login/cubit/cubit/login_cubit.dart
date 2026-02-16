import 'package:bloc/bloc.dart';
import 'package:focus_app/core/result_widget.dart';
import 'package:focus_app/features/authentification/data/authentification_repository_impl.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  //TODO: refactor
  AuthentificationRepositoryImpl authentificationRepository =
      AuthentificationRepositoryImpl();

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    // TODO indicator
    final result = await authentificationRepository.signIn(email, password);
    switch (result) {
      case Success():
        emit(LoginSuccess());
      case Failure(:final message):
        emit(LoginFailure(message));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    // TODO indicator
    final result = await authentificationRepository.signInWithGoogle();
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
      await authentificationRepository.signOut();
      emit(LoginInitial());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> forgetPassword(String email) async {
    authentificationRepository.forgetPassword(email);
  }
}
