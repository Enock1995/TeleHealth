import '../../../core/models/doctor_model.dart';

abstract class DoctorRepository {
  Future<List<DoctorModel>> searchDoctors({String? query, String? specialty});

  Future<DoctorModel> getDoctor(int id);
}
