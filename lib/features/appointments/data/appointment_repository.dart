import '../../../core/models/appointment_model.dart';

abstract class AppointmentRepository {
  Future<List<AppointmentModel>> myAppointments();

  Future<AppointmentModel> bookAppointment({
    required int doctorId,
    required String doctorName,
    required String specialty,
    required DateTime date,
    required String time,
    required String reason,
    required double fee,
  });

  Future<void> cancelAppointment(int id);
}
