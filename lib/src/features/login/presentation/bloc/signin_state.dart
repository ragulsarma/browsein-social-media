part of 'signin_cubit.dart';

class SignInState {
  const SignInState();
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignUpLoading extends SignInState {}

class SignInSuccess extends SignInState {}

class SignUpSuccess extends SignInState {}

class SignInError extends SignInState {
  final String message;

  const SignInError(this.message);
}

class SignUpError extends SignInState {
  final String message;

  const SignUpError(this.message);
}
