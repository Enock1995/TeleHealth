import '../../../core/models/user_model.dart';
import '../../../core/network/api_exception.dart';
import 'auth_repository.dart';

/// Fake, in-memory stand-in for the real backend. Data resets every time
/// the app restarts — that's expected, this is for UI demos and building
/// out screens before any backend/Firebase project exists.
class FakeAuthRepository implements AuthRepository {
  final Map<String, Map<String, dynamic>> _usersByEmail = {};
  int _nextId = 1;

  Future<void> _simulateNetwork() =>
      Future.delayed(const Duration(milliseconds: 600));

  @override
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
  }) async {
    await _simulateNetwork();

    if (_usersByEmail.containsKey(email)) {
      throw ApiException('An account with this email already exists', 422);
    }

    final userData = {
      'id': _nextId++,
      'name': name,
      'email': email,
      'phone': phone,
      'role': 'patient',
      'status': 'active',
      '_password': password,
      'patient': {
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'address': address,
        'emergency_contact_name': emergencyContactName,
        'emergency_contact_phone': emergencyContactPhone,
      },
      'doctor': null,
    };

    _usersByEmail[email] = userData;
    return _toAuthResult(userData);
  }

  @override
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
  }) async {
    await _simulateNetwork();

    if (_usersByEmail.containsKey(email)) {
      throw ApiException('An account with this email already exists', 422);
    }

    final userData = {
      'id': _nextId++,
      'name': name,
      'email': email,
      'phone': phone,
      'role': 'doctor',
      'status': 'active',
      '_password': password,
      'patient': null,
      'doctor': {
        'specialty': specialty,
        'qualifications': qualifications,
        'registration_number': registrationNumber,
        'years_experience': yearsExperience ?? 0,
        'consultation_fee': consultationFee ?? 0,
        'bio': bio,
        'languages': languages,
        'verification_status': 'pending',
      },
    };

    _usersByEmail[email] = userData;
    return _toAuthResult(userData);
  }

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    await _simulateNetwork();

    final userData = _usersByEmail[email];

    if (userData == null || userData['_password'] != password) {
      throw ApiException('Invalid credentials', 401);
    }

    return _toAuthResult(userData);
  }

  @override
  Future<void> logout() async {
    await _simulateNetwork();
  }

  @override
  Future<UserModel> me() async {
    throw ApiException('Not available in demo mode', 501);
  }

  AuthResult _toAuthResult(Map<String, dynamic> userData) {
    final user = UserModel.fromJson(userData);
    return AuthResult(user: user, token: 'fake-token-${userData['id']}');
  }
}
