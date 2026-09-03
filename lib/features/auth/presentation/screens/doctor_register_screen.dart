import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';
import '../../../../core/theme/app_colors.dart';

class DoctorRegisterScreen extends StatefulWidget {
  const DoctorRegisterScreen({super.key});

  @override
  State<DoctorRegisterScreen> createState() => _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _qualificationsController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _yearsExperienceController = TextEditingController();
  final _consultationFeeController = TextEditingController();
  final _bioController = TextEditingController();
  final _languagesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _specialtyController.dispose();
    _qualificationsController.dispose();
    _registrationNumberController.dispose();
    _yearsExperienceController.dispose();
    _consultationFeeController.dispose();
    _bioController.dispose();
    _languagesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final languages = _languagesController.text.trim().isEmpty
        ? null
        : _languagesController.text.split(',').map((e) => e.trim()).toList();

    final success = await auth.registerDoctor(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      password: _passwordController.text,
      passwordConfirmation: _confirmController.text,
      specialty: _specialtyController.text.trim(),
      qualifications: _qualificationsController.text.trim().isEmpty
          ? null
          : _qualificationsController.text.trim(),
      registrationNumber: _registrationNumberController.text.trim(),
      yearsExperience: int.tryParse(_yearsExperienceController.text.trim()),
      consultationFee: double.tryParse(_consultationFeeController.text.trim()),
      bio: _bioController.text.trim().isEmpty
          ? null
          : _bioController.text.trim(),
      languages: languages,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Registration')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warningBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Your account will be reviewed by an administrator before you can accept appointments.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.warningText,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Enter a valid email'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone (optional)',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _specialtyController,
                  decoration: const InputDecoration(labelText: 'Specialty'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _registrationNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Professional registration number',
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _yearsExperienceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Years experience',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _consultationFeeController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Fee (USD)',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _qualificationsController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Qualifications (optional)',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _languagesController,
                  decoration: const InputDecoration(
                    labelText: 'Languages, comma separated (optional)',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Short bio (optional)',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (v) => (v == null || v.length < 8)
                      ? 'Minimum 8 characters'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
                  ),
                  validator: (v) => v != _passwordController.text
                      ? 'Passwords do not match'
                      : null,
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: auth.status == AuthStatus.loading ? null : _submit,
                  child: auth.status == AuthStatus.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Create Account'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
