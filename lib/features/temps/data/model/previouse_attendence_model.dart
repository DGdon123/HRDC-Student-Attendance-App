class AttendaceStudentModel {
  final String name;
  final String profileLogo;
  final String rollNo;
  bool attendaceStatus;

  AttendaceStudentModel(
      {required this.name,
      required this.rollNo,
      required this.profileLogo,
      required this.attendaceStatus});

  static List<AttendaceStudentModel> studentAttendaceList = [
    AttendaceStudentModel(
        name: "Kancha Baba",
        profileLogo: "kk",
        attendaceStatus: false,
        rollNo: "1"),
    AttendaceStudentModel(
        name: "Ram Thapa",
        profileLogo: "kk",
        attendaceStatus: false,
        rollNo: "2"),
    AttendaceStudentModel(
        name: "Dolma Tamang",
        profileLogo: "kk",
        attendaceStatus: false,
        rollNo: "3"),
    AttendaceStudentModel(
        name: "Dolma Tamang",
        profileLogo: "kk",
        attendaceStatus: false,
        rollNo: "4"),
    AttendaceStudentModel(
        name: "Dolma Tamang",
        profileLogo: "kk",
        attendaceStatus: false,
        rollNo: "5"),
    AttendaceStudentModel(
        name: "Dolma Tamang",
        profileLogo: "kk",
        attendaceStatus: false,
        rollNo: "6"),
  ];
}
