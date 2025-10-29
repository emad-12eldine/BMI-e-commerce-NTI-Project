import 'package:basket_ball_conuter/src/models/user.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final bool isLogin;
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState({
    this.isLogin = true,
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLogin,
    AuthStatus? status,
    User? user,
    String? error,
  }) {
    return AuthState(
      isLogin: isLogin ?? this.isLogin,
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
