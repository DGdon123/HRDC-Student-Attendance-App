// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ReportModel {
  final List<String> labels;
  final List<String> males;
  final List<String> females;
  final List<String> others;
  ReportModel({
    required this.labels,
    required this.males,
    required this.females,
    required this.others,
  });

  ReportModel copyWith({
    List<String>? labels,
    List<String>? males,
    List<String>? females,
    List<String>? others,
  }) {
    return ReportModel(
      labels: labels ?? this.labels,
      males: males ?? this.males,
      females: females ?? this.females,
      others: others ?? this.others,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'labels': labels,
      'males': males,
      'females': females,
      'others': others,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      labels: List.from(map['labels']).map((e) => e.toString()).toList(),
      males: List.from(map['datasets'][0]['male'])
          .map((e) => e.toString())
          .toList(),
      females: List.from(map['datasets'][1]['female'])
          .map((e) => e.toString())
          .toList(),
      others: List.from(map['datasets'][2]['other'])
          .map((e) => e.toString())
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportModel.fromJson(String source) =>
      ReportModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Report(labels: $labels, males: $males, females: $females, others: $others)';
  }

  @override
  bool operator ==(covariant ReportModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.labels, labels) &&
        listEquals(other.males, males) &&
        listEquals(other.females, females) &&
        listEquals(other.others, others);
  }

  @override
  int get hashCode {
    return labels.hashCode ^
        males.hashCode ^
        females.hashCode ^
        others.hashCode;
  }
}
