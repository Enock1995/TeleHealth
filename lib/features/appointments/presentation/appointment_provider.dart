import 'package:flutter/foundation.dart';
import '../../../core/models/appointment_model.dart';
import '../data/appointment_repository.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentRepository _repository;

  AppointmentProvider(this._repository);

  bool isLoading = false;
  List<AppointmentModel> appointments = [];

  Future<void> loadAppointments() async {
    isLoading = true;
    notifyListeners();

    appointments = await _repository.myAppointments();

    isLoading = false;
    notifyListeners();
  }

  Future<void> bookAppointment({
    required int doctorId,
    required String doctorName,
    required String specialty,
    required DateTime date,
    required String time,
    required String reason,
    required double fee,
  }) async {
    await _repository.bookAppointment(
      doctorId: doctorId,
      doctorName: doctorName,
      specialty: specialty,
      date: date,
      time: time,
      reason: reason,
      fee: fee,
    );
    await loadAppointments();
  }

  Future<void> cancelAppointment(int id) async {
    await _repository.cancelAppointment(id);
    await loadAppointments();
  }
}
