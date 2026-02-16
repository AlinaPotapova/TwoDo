part of 'sign_up_cubit.dart';

@immutable
sealed class Sign_upState {}

final class SignUpInitial extends Sign_upState {}

final class SignUpLoading extends Sign_upState {}

final class SignUpSuccess extends Sign_upState {
  String get user => 'user'; // Placeholder getter
}

final class SignUpFailure extends Sign_upState {
  final String errorMessage;

  SignUpFailure(this.errorMessage);

  String get message => errorMessage;
}
