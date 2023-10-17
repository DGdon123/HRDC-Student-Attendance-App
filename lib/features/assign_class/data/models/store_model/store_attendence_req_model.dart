class StoreAttendenceRequestModel {
  final String classID;
  final String attendanceDate;
  final String attendanceDateAd;
  final String attendanceDateBs;
  final String school_id;
  final String teacher_id;
  final String section_id;
  final List<int> student_id;
  final List<int> reason_id;
  final List<int> status_id;
  StoreAttendenceRequestModel(
      {required this.classID,
      required this.attendanceDate,
      required this.attendanceDateAd,
      required this.attendanceDateBs,
      required this.school_id,
      required this.teacher_id,
      required this.section_id,
      required this.student_id,
      required this.reason_id,
      required this.status_id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'class_id': classID,
      'attendance_date': attendanceDate,
      'attendance_date_ad': attendanceDateAd,
      'attendance_date_bs': attendanceDateBs,
      'school_id': school_id,
      'teacher_id': teacher_id,
      'section_id': section_id,
      "student_id[]": student_id,
      "status[]": status_id,
      "reason_id[]": reason_id
    };
  }
}
