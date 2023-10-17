// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LoginResponseModel {
  final String userId;
  final String userName;
  final String token;
  final String phone;
  LoginResponseModel({
    required this.userId,
    required this.userName,
    required this.token,
    required this.phone,
  });

  LoginResponseModel copyWith(
      {String? userId, String? userName, String? token, String? phone}) {
    return LoginResponseModel(
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        token: token ?? this.token,
        phone: phone ?? this.phone);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'username': userName,
      'token': token,
    };
  }

  factory LoginResponseModel.fromMap(Map<String, dynamic> map) {
    return LoginResponseModel(
        userId: map['user_id'] ?? "",
        userName: map['username'] ?? "",
        token: map['token'] ?? "",
        phone: map['phone'] ?? "");
  }

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromJson(String source) =>
      LoginResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LoginResponseModel(userId: $userId, userName: $userName, token: $token)';

  @override
  bool operator ==(covariant LoginResponseModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.userName == userName &&
        other.token == token;
  }

  @override
  int get hashCode => userId.hashCode ^ userName.hashCode ^ token.hashCode;
}
