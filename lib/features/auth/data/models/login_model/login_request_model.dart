// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LoginRequestModel {
  final String email;
  final String password;
  final String device_token;
  LoginRequestModel({
    required this.email,
    required this.password,
    required this.device_token,
  });

  LoginRequestModel copyWith({
    String? email,
    String? password,
    String? device_token,
  }) {
    return LoginRequestModel(
      email: email ?? this.email,
      password: password ?? this.password,
      device_token: device_token ?? this.device_token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'device_token': device_token,
    };
  }

  factory LoginRequestModel.fromMap(Map<String, dynamic> map) {
    return LoginRequestModel(
      email: map['email'] ?? "",
      password: map['password'] ?? "",
      device_token: map['device_token'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginRequestModel.fromJson(String source) =>
      LoginRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LoginRequestModel(email: $email, password: $password, device_token: $device_token)';

  @override
  bool operator ==(covariant LoginRequestModel other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.password == password &&
        other.device_token == device_token;
  }

  @override
  int get hashCode =>
      email.hashCode ^ password.hashCode ^ device_token.hashCode;
}
