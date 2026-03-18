import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_do/features/authentication/domain/auth_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepo) : super(SignUpInitial());

  final AuthRepository _authRepo;

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
