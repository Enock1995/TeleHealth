class DoctorModel {
  final int id;
  final String name;
  final String specialty;
  final int yearsExperience;
  final double consultationFee;
  final String? bio;
  final List<String> languages;
  final double rating;
  final int reviewCount;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.yearsExperience,
    required this.consultationFee,
    this.bio,
    this.languages = const [],
    this.rating = 0,
    this.reviewCount = 0,
  });
}
