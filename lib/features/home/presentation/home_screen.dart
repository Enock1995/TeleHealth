import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../shared/widgets/placeholder_screen.dart';
import '../../doctors/presentation/screens/find_doctor_screen.dart';
import '../../appointments/presentation/screens/my_appointments_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Telehealth'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${user?.name ?? ''}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (user?.isDoctor == true)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warningBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Your profile is pending admin verification. You'll be notified once approved.",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.warningText,
                    ),
                  ),
                ),
              if (user?.isPatient == true) ...[
                const SizedBox(height: 20),
                _ActionCard(
                  icon: Icons.search_rounded,
                  title: 'Find a Doctor',
                  subtitle: 'Search by specialty or availability',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FindDoctorScreen()),
                  ),
                ),
                const SizedBox(height: 12),
                _ActionCard(
                  icon: Icons.calendar_today_rounded,
                  title: 'My Appointments',
                  subtitle: 'View, reschedule, or cancel',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyAppointmentsScreen(),
                    ),
                  ),
                ),
              ],
              if (user?.isDoctor == true) ...[
                const SizedBox(height: 20),
                _ActionCard(
                  icon: Icons.calendar_today_rounded,
                  title: 'My Appointments',
                  subtitle: 'Coming soon',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PlaceholderScreen(
                        title: 'My Appointments',
                        icon: Icons.calendar_today_rounded,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _ActionCard(
                  icon: Icons.schedule_rounded,
                  title: 'Set Availability',
                  subtitle: 'Coming soon',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PlaceholderScreen(
                        title: 'Set Availability',
                        icon: Icons.schedule_rounded,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.tealLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.teal, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
