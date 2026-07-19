import 'package:flutter/material.dart';

import 'app_session.dart';

const Color _primaryBlue = Color(0xFF3157F6);
const Color _background = Color(0xFFF8FAFD);
const Color _textPrimary = Color(0xFF202532);
const Color _textSecondary = Color(0xFF788394);
const Color _border = Color(0xFFE2E7EF);

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  String _displayName = 'Administrator';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final SessionProfile? profile = await AppSession.getProfile();

      if (!mounted || profile == null) {
        return;
      }

      setState(() {
        _displayName = profile.displayName;
        _email = profile.email;
      });
    } catch (_) {
      // Keep fallback values if local profile storage is unavailable.
    }
  }

  String get _profileInitials {
    final List<String> words = _displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((String word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return 'A';
    }

    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }

    return '${words.first.substring(0, 1)}'
            '${words.last.substring(0, 1)}'
        .toUpperCase();
  }

  void _handleNavigation(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This admin section will be implemented next.'),
        ),
      );
    }
  }

  void _showAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$action selected')),
    );
  }

  Future<void> _openAdminProfile() async {
    final bool? shouldLogOut = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9DEE8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 26),
                CircleAvatar(
                  radius: 44,
                  backgroundColor: const Color(0xFFE8ECFF),
                  child: Text(
                    _profileInitials,
                    style: const TextStyle(
                      color: _primaryBlue,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _displayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _email.isEmpty
                      ? 'Email will appear after your next login'
                      : _email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FC),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: const Color(0xFFE5E9F0),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.admin_panel_settings_outlined,
                        color: _primaryBlue,
                        size: 21,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Administrator account',
                          style: TextStyle(
                            color: _textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(sheetContext).pop(true);
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Log out'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD32F2F),
                      side: const BorderSide(
                        color: Color(0xFFFFCDD2),
                      ),
                      backgroundColor: const Color(0xFFFFF7F7),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldLogOut != true) {
      return;
    }

    try {
      await AppSession.logOut();
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to clear the saved login session.'),
        ),
      );
      return;
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<void>(
      canPop: false,
      child: Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 62,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: IconButton(
            tooltip: 'Admin profile',
            onPressed: _openAdminProfile,
            icon: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFE8ECFF),
              child: Text(
                _profileInitials,
                style: const TextStyle(
                  color: _primaryBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          'NEXTERN',
          style: TextStyle(
            color: _primaryBlue,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.7,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showAction('Notifications');
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF414958),
            ),
          ),
          const SizedBox(width: 7),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
        children: [
          const Text(
            'Overview',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'System health and high-level metrics.',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 19),

          const _MetricCard(
            icon: Icons.people_outline,
            value: '1,248',
            label: 'Active Users',
            change: '+12%',
          ),
          const SizedBox(height: 13),

          const _MetricCard(
            icon: Icons.analytics_outlined,
            value: '84%',
            label: 'Avg. Program Completion',
            change: '-2%',
            showProgress: true,
          ),
          const SizedBox(height: 21),

          const Text(
            'Quick Actions',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: () {
              _showAction('Post Announcement');
            },
            icon: const Icon(Icons.add, size: 17),
            label: const Text('Post Announcement'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size.fromHeight(47),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.people_outline,
                  label: 'Users',
                  onPressed: () {
                    _showAction('Users');
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.menu_book_outlined,
                  label: 'Programs',
                  onPressed: () {
                    _showAction('Programs');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Submissions',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {
                  _showAction('View all submissions');
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: _primaryBlue,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const _SubmissionCard(
            icon: Icons.bar_chart_outlined,
            title: 'Data Analysis Module 3',
            student: 'Jane Doe',
            time: '10 mins ago',
          ),
          const SizedBox(height: 10),

          const _SubmissionCard(
            icon: Icons.design_services_outlined,
            title: 'UX Wireframing Challenge',
            student: 'Alex Smith',
            time: '45 mins ago',
          ),
          const SizedBox(height: 10),

          const _SubmissionCard(
            icon: Icons.code_outlined,
            title: 'React Component Architecture',
            student: 'Sarah Connor',
            time: '2 hrs ago',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _handleNavigation,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _primaryBlue,
        unselectedItemColor: const Color(0xFF8A94A4),
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign_outlined),
            label: 'Updates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.change,
    this.showProgress = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final String change;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 19,
                color: const Color(0xFF6F7989),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F5F8),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  change,
                  style: const TextStyle(
                    color: Color(0xFF798394),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 29,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 11,
            ),
          ),
          if (showProgress) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(
              value: 0.84,
              minHeight: 4,
              color: _primaryBlue,
              backgroundColor: Color(0xFFE8ECF5),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF343B48),
        minimumSize: const Size.fromHeight(45),
        side: const BorderSide(color: _border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class _SubmissionCard extends StatelessWidget {
  const _SubmissionCard({
    required this.icon,
    required this.title,
    required this.student,
    required this.time,
  });

  final IconData icon;
  final String title;
  final String student;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 37,
            height: 37,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3FF),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              icon,
              size: 19,
              color: _primaryBlue,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Submitted by $student • $time',
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE9EDFF),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              'Pending\nReview',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _primaryBlue,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}