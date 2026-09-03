import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../appointment_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/appointment_model.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentProvider>().loadAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.teal),
            )
          : provider.appointments.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.tealLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.calendar_today_rounded,
                        color: AppColors.teal,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No appointments yet',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Book a doctor to see it here.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.appointments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) =>
                  _AppointmentCard(appointment: provider.appointments[index]),
            ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  const _AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  appointment.doctorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _StatusBadge(status: appointment.status),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            appointment.specialty,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 5),
              Text(
                '${appointment.date.day}/${appointment.date.month}/${appointment.date.year}',
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.access_time_rounded,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 5),
              Text(
                appointment.time,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '\$${appointment.fee.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          if (appointment.status == AppointmentStatus.confirmed ||
              appointment.status == AppointmentStatus.pending) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context
                    .read<AppointmentProvider>()
                    .cancelAppointment(appointment.id),
                style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final AppointmentStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final String label;

    switch (status) {
      case AppointmentStatus.confirmed:
        color = AppColors.teal;
        label = 'Confirmed';
        break;
      case AppointmentStatus.pending:
        color = AppColors.warningText;
        label = 'Pending';
        break;
      case AppointmentStatus.cancelled:
        color = AppColors.danger;
        label = 'Cancelled';
        break;
      case AppointmentStatus.completed:
        color = AppColors.textSecondary;
        label = 'Completed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
