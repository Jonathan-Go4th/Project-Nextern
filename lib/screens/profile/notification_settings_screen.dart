import 'package:flutter/material.dart';

const Color _primaryBlue = Color(0xFF3F5BF6);
const Color _background = Color(0xFFF7F9FC);
const Color _textPrimary = Color(0xFF202533);
const Color _textSecondary = Color(0xFF7C8798);

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _emailNotifs = true;
  bool _pushNotifs = true;
  bool _courseUpdates = true;
  bool _assignmentReminders = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notification Settings',
          style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: _textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text('General Notifications', style: TextStyle(color: _primaryBlue, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildSwitchTile('Email Notifications', 'Receive daily summaries and alerts via email.', _emailNotifs, (val) => setState(() => _emailNotifs = val)),
          const SizedBox(height: 12),
          _buildSwitchTile('Push Notifications', 'Receive instant alerts on your device.', _pushNotifs, (val) => setState(() => _pushNotifs = val)),
          
          const SizedBox(height: 32),
          const Text('Course Notifications', style: TextStyle(color: _primaryBlue, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildSwitchTile('Course Updates', 'Get notified about new modules and announcements.', _courseUpdates, (val) => setState(() => _courseUpdates = val)),
          const SizedBox(height: 12),
          _buildSwitchTile('Assignment Reminders', 'Get notified 24 hours before an assignment is due.', _assignmentReminders, (val) => setState(() => _assignmentReminders = val)),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E9F0))),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(subtitle, style: const TextStyle(color: _textSecondary, fontSize: 13)),
        ),
        value: value,
        activeColor: Colors.white,
        activeTrackColor: _primaryBlue,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
