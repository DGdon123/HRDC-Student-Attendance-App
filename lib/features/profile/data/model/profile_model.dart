// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProfileModel {
  final String name;
  final String email;
  final String contact;
  final String permanent_address;
  final String temporary_address;
  final String school;
  final String gender;
  ProfileModel({
    required this.name,
    required this.email,
    required this.contact,
    required this.permanent_address,
    required this.temporary_address,
    required this.school,
    required this.gender,
  });

  ProfileModel copyWith({
    String? name,
    String? email,
    String? contact,
    String? permanent_address,
    String? temporary_address,
    String? school,
    String? gender,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      contact: contact ?? this.contact,
      permanent_address: permanent_address ?? this.permanent_address,
      temporary_address: temporary_address ?? this.temporary_address,
      school: school ?? this.school,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'contact': contact,
      'permanent_address': permanent_address,
      'temporary_address': temporary_address,
      'school': school,
      'gender': gender,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      contact: map['contact'] ?? "",
      permanent_address: map['permanent_address'] ?? "",
      temporary_address: map['temporary_address'] ?? "",
      school: map['school'] ?? "",
      gender: map['gender'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProfileModel(name: $name, email: $email, contact: $contact, permanent_address: $permanent_address, temporary_address: $temporary_address, school: $school, gender: $gender)';
  }

  @override
  bool operator ==(covariant ProfileModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.contact == contact &&
        other.permanent_address == permanent_address &&
        other.temporary_address == temporary_address &&
        other.school == school &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        contact.hashCode ^
        permanent_address.hashCode ^
        temporary_address.hashCode ^
        school.hashCode ^
        gender.hashCode;
  }
}
