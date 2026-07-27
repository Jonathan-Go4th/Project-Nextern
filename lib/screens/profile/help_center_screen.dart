import 'package:flutter/material.dart';

const Color _primaryBlue = Color(0xFF3F5BF6);
const Color _background = Color(0xFFF7F9FC);
const Color _textPrimary = Color(0xFF202533);
const Color _textSecondary = Color(0xFF7C8798);

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  final List<Map<String, String>> _faqs = const [
    {'q': 'How do I change my password?', 'a': 'Go to Profile > Security & Password to update your credentials.'},
    {'q': 'Where can I find my certificates?', 'a': 'You can download your certificates in the Tasks screen under the "Completed" tab.'},
    {'q': 'How do I submit an assignment?', 'a': 'Navigate to your active course, open the weekly learning content, and drop your files into the assignment dropbox.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Help Center',
          style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: _textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E9F0)),
              ),
              child: Column(
                children: _faqs.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final Map<String, String> faq = entry.value;
                  final bool isLast = index == _faqs.length - 1;

                  return Column(
                    children: [
                      ExpansionTile(
                        title: Text(
                          faq['q']!,
                          style: const TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        iconColor: _primaryBlue,
                        collapsedIconColor: const Color(0xFFC0C7D5),
                        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        children: [
                          Text(
                            faq['a']!,
                            style: const TextStyle(color: _textSecondary, fontSize: 14, height: 1.5),
                          ),
                        ],
                      ),
                      if (!isLast) const Divider(height: 1, color: Color(0xFFF0F3F8)),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE8ECFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.support_agent, color: _primaryBlue, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Still need help?',
                    style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Our support team is always ready to assist you with any issues.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contacting Support...')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Contact Support', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
