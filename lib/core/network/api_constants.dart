class ApiConstants {
  // Android emulator reaches your host machine's localhost via 10.0.2.2.
  // Swap for your real API URL when you deploy or test on a physical device.
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  static const String registerPatient = '/auth/register/patient';
  static const String registerDoctor = '/auth/register/doctor';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
}
