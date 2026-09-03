import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../appointment_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/doctor_model.dart';

class BookAppointmentScreen extends StatefulWidget {
  final DoctorModel doctor;

  const BookAppointmentScreen({super.key, required this.doctor});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _reasonController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedTime;
  bool _submitting = false;

  static const _timeSlots = [
    '09:00 AM',
    '10:30 AM',
    '12:00 PM',
    '02:00 PM',
    '03:30 PM',
    '05:00 PM',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a date and time')),
      );
      return;
    }

    setState(() => _submitting = true);

    await context.read<AppointmentProvider>().bookAppointment(
      doctorId: widget.doctor.id,
      doctorName: widget.doctor.name,
      specialty: widget.doctor.specialty,
      date: _selectedDate!,
      time: _selectedTime!,
      reason: _reasonController.text.trim(),
      fee: widget.doctor.consultationFee,
    );

    if (!mounted) return;

    Navigator.pop(context); // back to doctor profile
    Navigator.pop(context); // back to doctor list
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Appointment booked')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.tealLight,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.medical_services_outlined,
                      color: AppColors.teal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${widget.doctor.specialty} · \$${widget.doctor.consultationFee.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Date',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontSize: 15),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(),
                child: Text(
                  _selectedDate == null
                      ? 'Select a date'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Time',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontSize: 15),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((slot) {
                final selected = _selectedTime == slot;
                return ChoiceChip(
                  label: Text(slot),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedTime = slot),
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
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Reason for visit',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontSize: 15),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Briefly describe why you need this appointment',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onTeal,
                      ),
                    )
                  : const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
