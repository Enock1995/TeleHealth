import 'package:flutter/foundation.dart';
import '../data/auth_repository.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/models/user_model.dart';

enum AuthStatus { idle, loading, authenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider(this._repository);

  AuthStatus status = AuthStatus.idle;
  UserModel? user;
  String? errorMessage;

  Future<bool> registerPatient({
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
  }) {
    return _runAuthAction(
      () => _repository.registerPatient(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        dateOfBirth: dateOfBirth,
        gender: gender,
        address: address,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
      ),
    );
  }

  Future<bool> registerDoctor({
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
  }) {
    return _runAuthAction(
      () => _repository.registerDoctor(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        specialty: specialty,
        qualifications: qualifications,
        registrationNumber: registrationNumber,
        yearsExperience: yearsExperience,
        consultationFee: consultationFee,
        bio: bio,
        languages: languages,
      ),
    );
  }

  Future<bool> login({required String email, required String password}) {
    return _runAuthAction(
      () => _repository.login(email: email, password: password),
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    user = null;
    status = AuthStatus.idle;
    notifyListeners();
  }

  Future<bool> _runAuthAction(Future<AuthResult> Function() action) async {
    status = AuthStatus.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await action();
      user = result.user;
      status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong. Please try again.';
      status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }
}
