part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpSuccess extends SignUpState {
  String get user => 'user'; // Placeholder getter
}

final class SignUpFailure extends SignUpState {
  final String errorMessage;

  SignUpFailure(this.errorMessage);

  String get message => errorMessage;
}
