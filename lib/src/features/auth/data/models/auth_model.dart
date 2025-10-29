class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});
}

class SignUpRequest {
  final String email;
  final String password;
  final String fullName;
  final String? phone;
  final DateTime? dob;

  const SignUpRequest({
    required this.email,
    required this.password,
    required this.fullName,
    this.phone,
    this.dob,
  });
}
