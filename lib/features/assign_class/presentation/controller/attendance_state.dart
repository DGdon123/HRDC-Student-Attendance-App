import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../offline/offline_attendance/presentation/views/offline_attendance_screen.dart';

class StudentReasonNotifier extends StateNotifier<List<StudentReasonModel>> {
  StudentReasonNotifier(List<StudentReasonModel> initialReasons)
      : super(initialReasons);

  void updateStudentReason(StudentReasonModel updatedReason) {
    state = state.map((reason) {
      return reason.studentId == updatedReason.studentId
          ? updatedReason
          : reason;
    }).toList();
  }
}

final studentReasonsProvider =
    StateNotifierProvider<StudentReasonNotifier, List<StudentReasonModel>>(
  (ref) => StudentReasonNotifier([]), // Provide the initial value here
);
