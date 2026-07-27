import 'package:flutter/material.dart';

const Color _primaryBlue = Color(0xFF3157F6);
const Color _background = Color(0xFFF8FAFD);
const Color _textPrimary = Color(0xFF202532);
const Color _textSecondary = Color(0xFF788394);
const Color _border = Color(0xFFE2E7EF);

class AdminSecurityScreen extends StatefulWidget {
  const AdminSecurityScreen({super.key});

  @override
  State<AdminSecurityScreen> createState() => _AdminSecurityScreenState();
}

class _AdminSecurityScreenState extends State<AdminSecurityScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _twoFactorAuth = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePassword() {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New passwords do not match.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }
    if (_currentPasswordController.text.isEmpty || _newPasswordController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all password fields.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password updated successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Security & Password', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Change Password', style: TextStyle(color: _primaryBlue, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildPasswordField('Current Password', _currentPasswordController),
            const SizedBox(height: 16),
            _buildPasswordField('New Password', _newPasswordController),
            const SizedBox(height: 16),
            _buildPasswordField('Confirm New Password', _confirmPasswordController),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Update Password', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 48),
            const Text('Extra Security', style: TextStyle(color: _primaryBlue, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: SwitchListTile(
                activeColor: _primaryBlue,
                title: const Text('Two-Factor Authentication (2FA)', style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                subtitle: const Text('Require a security code on every login attempt.', style: TextStyle(color: _textSecondary, fontSize: 12)),
                value: _twoFactorAuth,
                onChanged: (val) {
                  setState(() => _twoFactorAuth = val);
                  if (val) {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('2FA Setup email sent.')));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _primaryBlue)),
          ),
        ),
      ],
    );
  }
}
