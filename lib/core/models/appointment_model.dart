enum AppointmentStatus { pending, confirmed, cancelled, completed }

class AppointmentModel {
  final int id;
  final int doctorId;
  final String doctorName;
  final String specialty;
  final DateTime date;
  final String time;
  final String reason;
  final double fee;
  final AppointmentStatus status;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.reason,
    required this.fee,
    this.status = AppointmentStatus.pending,
  });

  AppointmentModel copyWith({AppointmentStatus? status}) {
    return AppointmentModel(
      id: id,
      doctorId: doctorId,
      doctorName: doctorName,
      specialty: specialty,
      date: date,
      time: time,
      reason: reason,
      fee: fee,
      status: status ?? this.status,
    );
  }
}
