import 'package:bloc/bloc.dart';
import 'package:focus_app/domain/repos/login.repository.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  LoginRepository loginRepository = LoginRepository();

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      await loginRepository.authenticate(email, password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(LoginInitial());
  }

  Future<void> forgetPassword(String email) async {
    // Implement forget password logic here
  }
}

