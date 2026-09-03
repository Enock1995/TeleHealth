import '../../../core/models/appointment_model.dart';
import 'appointment_repository.dart';

class FakeAppointmentRepository implements AppointmentRepository {
  final List<AppointmentModel> _appointments = [];
  int _nextId = 1;

  Future<void> _simulateNetwork() =>
      Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<List<AppointmentModel>> myAppointments() async {
    await _simulateNetwork();
    final sorted = [..._appointments]..sort((a, b) => a.date.compareTo(b.date));
    return sorted;
  }

  @override
  Future<AppointmentModel> bookAppointment({
    required int doctorId,
    required String doctorName,
    required String specialty,
    required DateTime date,
    required String time,
    required String reason,
    required double fee,
  }) async {
    await _simulateNetwork();

    final appointment = AppointmentModel(
      id: _nextId++,
      doctorId: doctorId,
      doctorName: doctorName,
      specialty: specialty,
      date: date,
      time: time,
      reason: reason,
      fee: fee,
      status: AppointmentStatus.confirmed,
    );

    _appointments.add(appointment);
    return appointment;
  }

  @override
  Future<void> cancelAppointment(int id) async {
    await _simulateNetwork();
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(
        status: AppointmentStatus.cancelled,
      );
    }
  }
}
