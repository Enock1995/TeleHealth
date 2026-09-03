import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../doctor_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/doctor_model.dart';
import 'doctor_profile_screen.dart';

class FindDoctorScreen extends StatefulWidget {
  const FindDoctorScreen({super.key});

  @override
  State<FindDoctorScreen> createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends State<FindDoctorScreen> {
  static const _specialties = [
    'All',
    'General Practice',
    'Pediatrics',
    'Dermatology',
    'Cardiology',
    'Mental Health',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorProvider>().loadDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DoctorProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Find a Doctor')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: provider.updateQuery,
              decoration: const InputDecoration(
                hintText: 'Search by name or specialty',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _specialties.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final specialty = _specialties[index];
                final selected = provider.selectedSpecialty == specialty;
                return ChoiceChip(
                  label: Text(specialty),
                  selected: selected,
                  onSelected: (_) => provider.updateSpecialty(specialty),
                  selectedColor: AppColors.tealLight,
                  labelStyle: TextStyle(
                    color: selected ? AppColors.teal : AppColors.textSecondary,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12.5,
                  ),
                  backgroundColor: AppColors.surface,
                  side: BorderSide(
                    color: selected ? AppColors.teal : AppColors.border,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.teal),
                  )
                : provider.doctors.isEmpty
                ? Center(
                    child: Text(
                      'No doctors found',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: provider.doctors.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) =>
                        _DoctorCard(doctor: provider.doctors[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final DoctorModel doctor;

  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DoctorProfileScreen(doctorId: doctor.id),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
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
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    doctor.specialty,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.teal,
                        size: 15,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${doctor.rating} (${doctor.reviewCount})',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '\$${doctor.consultationFee.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
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

  String _initials(String name) {
    final parts = name.replaceAll('Dr. ', '').trim().split(RegExp(r'\s+'));
    if (parts.length < 2)
      return parts.isNotEmpty ? parts[0][0].toUpperCase() : '?';
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
