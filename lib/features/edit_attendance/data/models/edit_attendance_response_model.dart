// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EditStoreAttendanceResponseModel {
  final String message;
  EditStoreAttendanceResponseModel({
    required this.message,
  });

  EditStoreAttendanceResponseModel copyWith({
    String? message,
  }) {
    return EditStoreAttendanceResponseModel(
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
    };
  }

  factory EditStoreAttendanceResponseModel.fromMap(Map<String, dynamic> map) {
    return EditStoreAttendanceResponseModel(
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EditStoreAttendanceResponseModel.fromJson(String source) =>
      EditStoreAttendanceResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EditStoreAttendanceResponseModel(message: $message)';

  @override
  bool operator ==(covariant EditStoreAttendanceResponseModel other) {
    if (identical(this, other)) return true;

    return other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
