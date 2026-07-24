import 'package:flutter/material.dart';

const Color _primaryBlue = Color(0xFF3157F6);
const Color _background = Color(0xFFF8FAFD);
const Color _textPrimary = Color(0xFF202532);
const Color _textSecondary = Color(0xFF788394);
const Color _border = Color(0xFFE2E7EF);

class AdminPreferencesScreen extends StatefulWidget {
  const AdminPreferencesScreen({super.key});

  @override
  State<AdminPreferencesScreen> createState() => _AdminPreferencesScreenState();
}

class _AdminPreferencesScreenState extends State<AdminPreferencesScreen> {
  bool _emailSupport = true;
  bool _pushSubmissions = true;
  String _dashboardView = 'Weekly';

  void _savePreferences() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferences saved successfully!')),
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
        title: const Text('Admin Preferences', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
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
            const Text('Notifications', style: TextStyle(color: _primaryBlue, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: _primaryBlue,
                    title: const Text('Push Notifications for Submissions', style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Get notified when a learner submits an assignment.', style: TextStyle(color: _textSecondary, fontSize: 12)),
                    value: _pushSubmissions,
                    onChanged: (val) => setState(() => _pushSubmissions = val),
                  ),
                  const Divider(height: 1, color: _border),
                  SwitchListTile(
                    activeColor: _primaryBlue,
                    title: const Text('Email for Support Feedback', style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Receive a daily email digest of new feedback.', style: TextStyle(color: _textSecondary, fontSize: 12)),
                    value: _emailSupport,
                    onChanged: (val) => setState(() => _emailSupport = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Dashboard Display', style: TextStyle(color: _primaryBlue, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Default Analytics View', style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                        builder: (context) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: ['Weekly', 'Monthly', 'Yearly'].map((String value) {
                                return ListTile(
                                  title: Text(value, style: TextStyle(color: _dashboardView == value ? _primaryBlue : _textPrimary, fontWeight: _dashboardView == value ? FontWeight.bold : FontWeight.normal)),
                                  trailing: _dashboardView == value ? const Icon(Icons.check, color: _primaryBlue) : null,
                                  onTap: () {
                                    setState(() => _dashboardView = value);
                                    Navigator.pop(context);
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: _background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_dashboardView, style: const TextStyle(color: _textPrimary, fontSize: 14)),
                          const Icon(Icons.arrow_drop_down, color: _textSecondary),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _savePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Save Preferences', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
