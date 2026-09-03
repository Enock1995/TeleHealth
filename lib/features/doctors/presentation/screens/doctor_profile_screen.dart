import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../doctor_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/doctor_model.dart';
import '../../../../features/appointments/presentation/screens/book_appointment_screen.dart';

class DoctorProfileScreen extends StatelessWidget {
  final int doctorId;

  const DoctorProfileScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DoctorProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Profile')),
      body: FutureBuilder<DoctorModel>(
        future: provider.getDoctor(doctorId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.teal),
            );
          }

          final doctor = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: const BoxDecoration(
                          color: AppColors.tealLight,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _initials(doctor.name),
                          style: const TextStyle(
                            color: AppColors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        doctor.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor.specialty,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.teal,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${doctor.rating} · ${doctor.reviewCount} reviews',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        label: 'Experience',
                        value: '${doctor.yearsExperience} yrs',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatTile(
                        label: 'Consultation',
                        value: '\$${doctor.consultationFee.toStringAsFixed(0)}',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatTile(
                        label: 'Languages',
                        value: doctor.languages.isEmpty
                            ? '—'
                            : doctor.languages.join(', '),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'About',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  doctor.bio ?? 'No bio provided yet.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookAppointmentScreen(doctor: doctor),
                    ),
                  ),
                  child: const Text('Book Appointment'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _initials(String name) {
    final parts = name.replaceAll('Dr. ', '').trim().split(RegExp(r'\s+'));
    if (parts.length < 2)
      return parts.isNotEmpty ? parts[0][0].toUpperCase() : '?';
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
