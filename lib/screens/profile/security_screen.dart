import 'package:flutter/material.dart';

const Color _primaryBlue = Color(0xFF3F5BF6);
const Color _background = Color(0xFFF7F9FC);
const Color _textPrimary = Color(0xFF202533);
const Color _textSecondary = Color(0xFF7C8798);

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _isSaving = false;
  String? _saveError;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateCurrentPassword(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'Enter your current password';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Enter a new password';
    }
    if (trimmed.length < 6) {
      return 'Use at least 6 characters';
    }
    if (trimmed == _currentPasswordController.text.trim()) {
      return 'New password must be different from current password';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Confirm your new password';
    }
    if (trimmed != _newPasswordController.text.trim()) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleUpdate() async {
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
        const SnackBar(content: Text('Password updated successfully!')),
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
          'Security & Password',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Update your password to keep your account secure.',
                style: TextStyle(color: _textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 32),
              _buildPasswordField(
                'Current Password',
                _currentPasswordController,
                _obscureCurrent,
                () => setState(() => _obscureCurrent = !_obscureCurrent),
                validator: _validateCurrentPassword,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                'New Password',
                _newPasswordController,
                _obscureNew,
                () => setState(() => _obscureNew = !_obscureNew),
                validator: _validateNewPassword,
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                'Confirm New Password',
                _confirmPasswordController,
                _obscureConfirm,
                () => setState(() => _obscureConfirm = !_obscureConfirm),
                validator: _validateConfirmPassword,
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
                  onPressed: _isSaving ? null : _handleUpdate,
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
                      : const Text('Update Password', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool isObscured,
    VoidCallback onToggle, {
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isObscured,
          enabled: !_isSaving,
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
            suffixIcon: IconButton(
              icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility, color: _textSecondary),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }
}