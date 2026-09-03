import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../features/auth/presentation/auth_provider.dart';
import 'placeholder_screen.dart';
import '../../features/doctors/presentation/screens/find_doctor_screen.dart';
import '../../features/appointments/presentation/screens/my_appointments_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final initials = _initials(user?.name ?? '');

    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.purple, AppColors.purpleDark],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.teal, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  user?.name ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    (user?.role ?? '').toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.onTeal,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _NavItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  onTap: () => Navigator.pop(context),
                ),
                _NavItem(
                  icon: Icons.search_rounded,
                  label: 'Find a Doctor',
                  onTap: () => _openFindDoctor(context),
                ),
                _NavItem(
                  icon: Icons.calendar_today_rounded,
                  label: 'My Appointments',
                  onTap: () => _openMyAppointments(context),
                ),
                _NavItem(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Consultations',
                  onTap: () => _openPlaceholder(
                    context,
                    'Consultations',
                    Icons.chat_bubble_outline_rounded,
                  ),
                ),
                _NavItem(
                  icon: Icons.description_outlined,
                  label: 'Prescriptions',
                  onTap: () => _openPlaceholder(
                    context,
                    'Prescriptions',
                    Icons.description_outlined,
                  ),
                ),
                _NavItem(
                  icon: Icons.folder_shared_outlined,
                  label: 'Medical Records',
                  onTap: () => _openPlaceholder(
                    context,
                    'Medical Records',
                    Icons.folder_shared_outlined,
                  ),
                ),
                _NavItem(
                  icon: Icons.local_pharmacy_outlined,
                  label: 'Pharmacy',
                  onTap: () => _openPlaceholder(
                    context,
                    'Pharmacy',
                    Icons.local_pharmacy_outlined,
                  ),
                ),
                _NavItem(
                  icon: Icons.payments_outlined,
                  label: 'Payments',
                  onTap: () => _openPlaceholder(
                    context,
                    'Payments',
                    Icons.payments_outlined,
                  ),
                ),
                _NavItem(
                  icon: Icons.notifications_none_rounded,
                  label: 'Notifications',
                  onTap: () => _openPlaceholder(
                    context,
                    'Notifications',
                    Icons.notifications_none_rounded,
                  ),
                ),
                const Divider(color: AppColors.border, height: 24),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  onTap: () => _openPlaceholder(
                    context,
                    'Profile',
                    Icons.person_outline_rounded,
                  ),
                ),
                _NavItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () => _openPlaceholder(
                    context,
                    'Settings',
                    Icons.settings_outlined,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          _NavItem(
            icon: Icons.logout_rounded,
            label: 'Log Out',
            color: AppColors.danger,
            onTap: () async {
              Navigator.pop(context);
              await context.read<AuthProvider>().logout();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/');
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _openMyAppointments(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MyAppointmentsScreen()),
    );
  }

  void _openFindDoctor(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FindDoctorScreen()),
    );
  }

  void _openPlaceholder(BuildContext context, String title, IconData icon) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaceholderScreen(title: title, icon: icon),
      ),
    );
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textSecondary, size: 21),
      title: Text(
        label,
        style: TextStyle(
          color: itemColor,
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
