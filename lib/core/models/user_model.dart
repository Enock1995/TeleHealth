class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String status;
  final Map<String, dynamic>? patient;
  final Map<String, dynamic>? doctor;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.status,
    this.patient,
    this.doctor,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      status: json['status'],
      patient: json['patient'],
      doctor: json['doctor'],
    );
  }

  bool get isPatient => role == 'patient';
  bool get isDoctor => role == 'doctor';
  bool get isAdmin => role == 'admin';
}
