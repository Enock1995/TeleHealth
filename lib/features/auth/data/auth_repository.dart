import '../../../core/models/user_model.dart';

class AuthResult {
  final UserModel user;
  final String token;

  AuthResult({required this.user, required this.token});
}

/// Contract only — no network/Firebase code here. FakeAuthRepository
/// implements this now; FirebaseAuthRepository will implement it later
/// with the exact same method signatures, so nothing above this layer
/// (AuthProvider, screens) needs to change when we switch.
abstract class AuthRepository {
  Future<AuthResult> registerPatient({
    required String name,
    required String email,
    String? phone,
    required String password,
    required String passwordConfirmation,
    String? dateOfBirth,
    String? gender,
    String? address,
    String? emergencyContactName,
    String? emergencyContactPhone,
  });

  Future<AuthResult> registerDoctor({
    required String name,
    required String email,
    String? phone,
    required String password,
    required String passwordConfirmation,
    required String specialty,
    String? qualifications,
    required String registrationNumber,
    int? yearsExperience,
    double? consultationFee,
    String? bio,
    List<String>? languages,
  });

  Future<AuthResult> login({required String email, required String password});

  Future<void> logout();

  Future<UserModel> me();
}
