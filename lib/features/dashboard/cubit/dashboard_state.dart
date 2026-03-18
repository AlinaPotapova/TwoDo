part of 'dashboard_cubit.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardSigningOut extends DashboardState {}

final class DashboardSignedOut extends DashboardState {}

final class DashboardFailure extends DashboardState {
  DashboardFailure(this.message);
  final String message;
}
