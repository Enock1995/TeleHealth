import 'package:flutter/foundation.dart';
import '../../../core/models/doctor_model.dart';
import '../data/doctor_repository.dart';

class DoctorProvider extends ChangeNotifier {
  final DoctorRepository _repository;

  DoctorProvider(this._repository);

  bool isLoading = false;
  List<DoctorModel> doctors = [];
  String searchQuery = '';
  String selectedSpecialty = 'All';

  Future<void> loadDoctors() async {
    isLoading = true;
    notifyListeners();

    doctors = await _repository.searchDoctors(
      query: searchQuery,
      specialty: selectedSpecialty,
    );

    isLoading = false;
    notifyListeners();
  }

  void updateQuery(String query) {
    searchQuery = query;
    loadDoctors();
  }

  void updateSpecialty(String specialty) {
    selectedSpecialty = specialty;
    loadDoctors();
  }

  Future<DoctorModel> getDoctor(int id) => _repository.getDoctor(id);
}
