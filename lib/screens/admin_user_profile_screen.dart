import 'package:flutter/material.dart';

const Color _primaryBlue = Color(0xFF3157F6);
const Color _background = Color(0xFFF8FAFD);
const Color _textPrimary = Color(0xFF202532);
const Color _textSecondary = Color(0xFF788394);
const Color _border = Color(0xFFE2E7EF);

class AdminUserProfileScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const AdminUserProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('User Profile', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: _textPrimary),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: _primaryBlue.withOpacity(0.1),
                    child: Text(
                      user['name'].substring(0, 1),
                      style: const TextStyle(color: _primaryBlue, fontWeight: FontWeight.bold, fontSize: 36),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(user['name'], style: const TextStyle(color: _textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(user['email'], style: const TextStyle(color: _textSecondary, fontSize: 14)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: user['status'] == 'Active' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user['status'],
                      style: TextStyle(
                        color: user['status'] == 'Active' ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Stats
            const Text('Performance Overview', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _StatCard(title: 'Programs Enrolled', value: '${user['enrolled']}')),
                const SizedBox(width: 12),
                const Expanded(child: _StatCard(title: 'Overall Progress', value: '78%')),
                const SizedBox(width: 12),
                const Expanded(child: _StatCard(title: 'Avg. Grade', value: 'A-')),
              ],
            ),
            const SizedBox(height: 32),

            // Recent Activity
            const Text('Recent Submissions', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border),
              ),
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('React Native - Module 1', style: TextStyle(fontWeight: FontWeight.bold, color: _textPrimary)),
                    subtitle: Text('Graded: A • 2 days ago', style: TextStyle(color: _textSecondary)),
                  ),
                  Divider(height: 1, color: _border),
                  ListTile(
                    leading: Icon(Icons.pending, color: Colors.orange),
                    title: Text('React Native - Module 2', style: TextStyle(fontWeight: FontWeight.bold, color: _textPrimary)),
                    subtitle: Text('Pending Review • 4 hours ago', style: TextStyle(color: _textSecondary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Last Login: Today, 8:45 AM', style: TextStyle(color: _textSecondary, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: _primaryBlue, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(color: _textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
