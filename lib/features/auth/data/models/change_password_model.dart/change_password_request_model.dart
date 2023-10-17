// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChangePasswordRequestModel {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;
  ChangePasswordRequestModel({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  ChangePasswordRequestModel copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmNewPassword,
  }) {
    return ChangePasswordRequestModel(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'current-password': currentPassword,
      'password': newPassword,
      'password_confirmation': confirmNewPassword,
    };
  }

  factory ChangePasswordRequestModel.fromMap(Map<String, dynamic> map) {
    return ChangePasswordRequestModel(
      currentPassword: map['current-password'] as String,
      newPassword: map['password'] as String,
      confirmNewPassword: map['password_confirmation'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChangePasswordRequestModel.fromJson(String source) =>
      ChangePasswordRequestModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ChangePasswordRequestModel(currentPassword: $currentPassword, newPassword: $newPassword, confirmNewPassword: $confirmNewPassword)';

  @override
  bool operator ==(covariant ChangePasswordRequestModel other) {
    if (identical(this, other)) return true;

    return other.currentPassword == currentPassword &&
        other.newPassword == newPassword &&
        other.confirmNewPassword == confirmNewPassword;
  }

  @override
  int get hashCode =>
      currentPassword.hashCode ^
      newPassword.hashCode ^
      confirmNewPassword.hashCode;
}
