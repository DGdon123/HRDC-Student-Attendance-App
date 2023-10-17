// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StoreAttendanceResponseModel {
  final String message;
  StoreAttendanceResponseModel({
    required this.message,
  });

  StoreAttendanceResponseModel copyWith({
    String? message,
  }) {
    return StoreAttendanceResponseModel(
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
    };
  }

  factory StoreAttendanceResponseModel.fromMap(Map<String, dynamic> map) {
    return StoreAttendanceResponseModel(
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreAttendanceResponseModel.fromJson(String source) =>
      StoreAttendanceResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'StoreAttendanceResponseModel(message: $message)';

  @override
  bool operator ==(covariant StoreAttendanceResponseModel other) {
    if (identical(this, other)) return true;

    return other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
