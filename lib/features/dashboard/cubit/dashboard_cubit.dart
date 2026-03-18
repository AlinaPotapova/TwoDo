import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_do/features/authentication/domain/auth_repository.dart';
import 'package:meta/meta.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._authRepo) : super(DashboardInitial());

  final AuthRepository _authRepo;

  Future<void> signOut() async {
    emit(DashboardSigningOut());
    try {
      await _authRepo.signOut();
      emit(DashboardSignedOut());
    } catch (e) {
      emit(DashboardFailure(e.toString()));
    }
  }
}
