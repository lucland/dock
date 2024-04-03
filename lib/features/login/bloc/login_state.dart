abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String userId;
  final String token;
  final bool isAdmin;

  LoginSuccess(
      {required this.userId, required this.token, required this.isAdmin});
}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}
