import 'package:flutter/material.dart';

import 'app_session.dart';
import 'profile/edit_profile_screen.dart';
import 'profile/notification_settings_screen.dart';
import 'profile/security_screen.dart';
import 'profile/feedback_screen.dart';
import 'profile/help_center_screen.dart';
import '../widgets/notification_badge.dart';

const Color _primaryBlue = Color(0xFF3F5BF6);
const Color _background = Color(0xFFF7F9FC);
const Color _textPrimary = Color(0xFF202533);
const Color _textSecondary = Color(0xFF7C8798);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3; // Profile tab index
  String _displayName = 'Alex';
  String _email = 'alex@example.com';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final SessionProfile? profile = await AppSession.getProfile();
      if (mounted && profile != null) {
        setState(() {
          _displayName = profile.displayName;
          _email = profile.email;
        });
      }
    } catch (_) {}
  }

  String get _profileInitials {
    final List<String> words = _displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((String word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) return 'U';
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
    return '${words.first.substring(0, 1)}${words.last.substring(0, 1)}'.toUpperCase();
  }

  void _selectNavigationItem(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else if (index == 1) {
      Navigator.of(context).pushReplacementNamed('/browse');
    } else if (index == 2) {
      Navigator.of(context).pushReplacementNamed('/tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        actions: [
          const NotificationBadge(iconColor: Color(0xFF3C4554)),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Header
              CircleAvatar(
                radius: 48,
                backgroundColor: const Color(0xFFE8ECFF),
                child: Text(
                  _profileInitials,
                  style: const TextStyle(
                    color: _primaryBlue,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _displayName,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _email,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              
              // Account Settings Block
              _buildSettingsBlock(
                title: 'Account Settings',
                items: [
                  _SettingsItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ));
                    },
                  ),
                  _SettingsItem(
                    icon: Icons.notifications_none,
                    title: 'Notification Settings',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NotificationSettingsScreen(),
                      ));
                    },
                  ),
                  _SettingsItem(
                    icon: Icons.security,
                    title: 'Security & Password',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SecurityScreen(),
                      ));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Support & Feedback Block
              _buildSettingsBlock(
                title: 'Support and Feedback',
                items: [
                  _SettingsItem(
                    icon: Icons.feedback_outlined,
                    title: 'Submit Feedback',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const FeedbackScreen(),
                      ));
                    },
                  ),
                  _SettingsItem(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HelpCenterScreen(),
                      ));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _selectNavigationItem,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _primaryBlue,
        unselectedItemColor: const Color(0xFF8993A2),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment_rounded),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsBlock({required String title, required List<_SettingsItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E9F0)),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final int index = entry.key;
              final _SettingsItem item = entry.value;
              final bool isLast = index == items.length - 1;

              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F3F8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item.icon, color: _primaryBlue, size: 20),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFFC0C7D5)),
                    onTap: item.onTap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      indent: 60,
                      endIndent: 20,
                      color: Color(0xFFF0F3F8),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
