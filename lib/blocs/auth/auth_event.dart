abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  LoginRequested(this.username);
}

class LogoutRequested extends AuthEvent {}
