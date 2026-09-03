import '../../../core/models/doctor_model.dart';
import 'doctor_repository.dart';

class FakeDoctorRepository implements DoctorRepository {
  final List<DoctorModel> _doctors = [
    DoctorModel(
      id: 1,
      name: 'Dr. Tendai Marufu',
      specialty: 'General Practice',
      yearsExperience: 9,
      consultationFee: 15,
      bio: 'Focused on everyday family health and preventive care.',
      languages: const ['English', 'Shona'],
      rating: 4.8,
      reviewCount: 132,
    ),
    DoctorModel(
      id: 2,
      name: 'Dr. Chiedza Moyo',
      specialty: 'Pediatrics',
      yearsExperience: 12,
      consultationFee: 20,
      bio: 'Caring for children from infancy through adolescence.',
      languages: const ['English', 'Shona', 'Ndebele'],
      rating: 4.9,
      reviewCount: 201,
    ),
    DoctorModel(
      id: 3,
      name: 'Dr. Farai Chikwava',
      specialty: 'Dermatology',
      yearsExperience: 7,
      consultationFee: 25,
      bio: 'Skin, hair, and nail conditions for all ages.',
      languages: const ['English'],
      rating: 4.6,
      reviewCount: 58,
    ),
    DoctorModel(
      id: 4,
      name: 'Dr. Rutendo Gumbo',
      specialty: 'Cardiology',
      yearsExperience: 15,
      consultationFee: 35,
      bio: 'Heart health, hypertension management, and cardiac screening.',
      languages: const ['English', 'Shona'],
      rating: 4.9,
      reviewCount: 176,
    ),
    DoctorModel(
      id: 5,
      name: 'Dr. Tafara Ndlovu',
      specialty: 'Mental Health',
      yearsExperience: 6,
      consultationFee: 22,
      bio: 'Anxiety, depression, and stress management support.',
      languages: const ['English', 'Ndebele'],
      rating: 4.7,
      reviewCount: 94,
    ),
  ];

  Future<void> _simulateNetwork() =>
      Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<List<DoctorModel>> searchDoctors({
    String? query,
    String? specialty,
  }) async {
    await _simulateNetwork();

    return _doctors.where((doctor) {
      final matchesQuery =
          query == null ||
          query.trim().isEmpty ||
          doctor.name.toLowerCase().contains(query.toLowerCase()) ||
          doctor.specialty.toLowerCase().contains(query.toLowerCase());
      final matchesSpecialty =
          specialty == null ||
          specialty == 'All' ||
          doctor.specialty == specialty;
      return matchesQuery && matchesSpecialty;
    }).toList();
  }

  @override
  Future<DoctorModel> getDoctor(int id) async {
    await _simulateNetwork();
    return _doctors.firstWhere((d) => d.id == id);
  }
}
