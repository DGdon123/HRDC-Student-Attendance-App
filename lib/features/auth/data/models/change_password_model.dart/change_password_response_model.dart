// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChangePasswordResponseModel {
  final String message;
  ChangePasswordResponseModel({
    required this.message,
  });

  ChangePasswordResponseModel copyWith({
    String? message,
  }) {
    return ChangePasswordResponseModel(
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
    };
  }

  factory ChangePasswordResponseModel.fromMap(Map<String, dynamic> map) {
    return ChangePasswordResponseModel(
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChangePasswordResponseModel.fromJson(String source) =>
      ChangePasswordResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChangePasswordResponseModel(message: $message)';

  @override
  bool operator ==(covariant ChangePasswordResponseModel other) {
    if (identical(this, other)) return true;

    return other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
