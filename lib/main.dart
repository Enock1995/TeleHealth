import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/fake_auth_repository.dart';
import 'features/auth/presentation/auth_provider.dart';
import 'features/auth/presentation/screens/welcome_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/patient_register_screen.dart';
import 'features/auth/presentation/screens/doctor_register_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/doctors/data/fake_doctor_repository.dart';
import 'features/doctors/presentation/doctor_provider.dart';
import 'features/appointments/data/fake_appointment_repository.dart';
import 'features/appointments/presentation/appointment_provider.dart';

void main() {
  // FakeAuthRepository for now — the app runs fully standalone, no backend
  // or Firebase project required yet. Once Firebase is ready, write
  // FirebaseAuthRepository (same AuthRepository interface) and swap this
  // one line. Nothing else in the app needs to change.
  final authRepository = FakeAuthRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(
          create: (_) => DoctorProvider(FakeDoctorRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => AppointmentProvider(FakeAppointmentRepository()),
        ),
      ],
      child: const TelehealthApp(),
    ),
  );
}

class TelehealthApp extends StatelessWidget {
  const TelehealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telehealth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: '/',
      routes: {
        '/': (_) => const WelcomeScreen(),
        '/login': (_) => const LoginScreen(),
        '/register/patient': (_) => const PatientRegisterScreen(),
        '/register/doctor': (_) => const DoctorRegisterScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}
