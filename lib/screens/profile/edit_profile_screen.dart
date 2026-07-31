import 'package:flutter/material.dart';

const Color _primaryBlue = Color(0xFF3F5BF6);
const Color _background = Color(0xFFF7F9FC);
const Color _textPrimary = Color(0xFF202533);

// A stricter email pattern: requires at least one character after the
// final dot (blocks things like "alex@example." while still allowing
// "alex@example.com").
final RegExp _emailRegex = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[\w\-]{2,}$');

// Basic phone check: allows digits, spaces, +, -, and parentheses, and
// requires at least 7 digits overall.
final RegExp _phoneDigitsRegex = RegExp(r'\d');

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: 'Alex Doe');
  final _emailController = TextEditingController(text: 'alex@example.com');
  final _phoneController = TextEditingController(text: '+1 234 567 8900');

  bool _isSaving = false;
  String? _saveError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Enter your full name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Enter your email address';
    }
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Enter your phone number';
    }
    final digitCount = _phoneDigitsRegex.allMatches(trimmed).length;
    if (digitCount < 7) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  Future<void> _handleSave() async {
    if (_isSaving) return; // prevent duplicate submissions

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() {
      _isSaving = true;
      _saveError = null;
    });

    try {
      // Mock API: simulate a save delay. Replace with a real service call
      // once the backend is available.
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _saveError = 'Something went wrong. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: _textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFFE8ECFF),
                      child: Text(
                        'AD',
                        style: TextStyle(color: _primaryBlue, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Photo upload is a static placeholder — not wired up,
                    // since there's no real backend to upload to with the
                    // mock API.
                    Container(
                      decoration: const BoxDecoration(color: _primaryBlue, shape: BoxShape.circle),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildTextField(
                'Full Name',
                _nameController,
                validator: _validateName,
                enabled: !_isSaving,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                'Email Address',
                _emailController,
                validator: _validateEmail,
                enabled: !_isSaving,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                'Phone Number',
                _phoneController,
                validator: _validatePhone,
                enabled: !_isSaving,
                keyboardType: TextInputType.phone,
              ),
              if (_saveError != null) ...[
                const SizedBox(height: 16),
                Text(
                  _saveError!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ],
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? Function(String?)? validator,
    bool enabled = true,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E9F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E9F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _primaryBlue, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}