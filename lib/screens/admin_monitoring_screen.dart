import 'package:flutter/material.dart';
import 'app_session.dart';

const Color _primaryBlue = Color(0xFF3157F6);
const Color _background = Color(0xFFF8FAFD);
const Color _textPrimary = Color(0xFF202532);
const Color _textSecondary = Color(0xFF788394);
const Color _border = Color(0xFFE2E7EF);

class AdminMonitoringScreen extends StatefulWidget {
  const AdminMonitoringScreen({super.key});

  @override
  State<AdminMonitoringScreen> createState() => _AdminMonitoringScreenState();
}

class _AdminMonitoringScreenState extends State<AdminMonitoringScreen> {
  int _selectedIndex = 1;
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

    if (words.isEmpty) return 'A';
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
    return '${words.first.substring(0, 1)}${words.last.substring(0, 1)}'.toUpperCase();
  }

  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;
    
    if (index == 0) {
      Navigator.of(context).pushReplacementNamed('/admin-home');
    } else {
      setState(() {
        _selectedIndex = index;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This admin section will be implemented next.'),
        ),
      );
    }
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
                      side: const BorderSide(color: Color(0xFFFFCDD2)),
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

    if (shouldLogOut != true) return;

    try {
      await AppSession.logOut();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to clear the saved login session.')),
      );
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () {},
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
            'Feedback & Monitoring',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Track learner progress and review submitted feedback.',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 19),

          // Progress Monitor
          Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progress Monitor',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: _primaryBlue, size: 20),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const _ProgressRow(
                  initials: 'AJ',
                  name: 'Alex Johnson',
                  track: 'Data Science Track',
                  progress: 0.85,
                  progressText: '85%',
                ),
                const Divider(height: 24, color: _border),
                const _ProgressRow(
                  initials: 'SK',
                  name: 'Sarah Kim',
                  track: 'UX Design Track',
                  progress: 0.62,
                  progressText: '62%',
                ),
                const Divider(height: 24, color: _border),
                const _ProgressRow(
                  initials: 'MR',
                  name: 'Michael Ross',
                  track: 'Frontend Engineering',
                  progress: 0.95,
                  progressText: '95%',
                ),
                const Divider(height: 24, color: _border),
                const _ProgressRow(
                  initials: 'PL',
                  name: 'Priya Lee',
                  track: 'Product Management',
                  progress: 0.40,
                  progressText: '40%',
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Text(
                    'View all progress',
                    style: TextStyle(color: _primaryBlue, fontSize: 13),
                  ),
                  label: const Icon(Icons.arrow_forward, size: 16, color: _primaryBlue),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Feedback Inbox
          Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Feedback Inbox',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '3 New',
                        style: TextStyle(
                          color: Color(0xFFD32F2F),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const _FeedbackItem(
                  name: 'Sarah Kim',
                  time: '2h ago',
                  message: 'The module on user research methods was incredibly detailed, but I felt the final assignment lacked clear rubrics...',
                  isUnread: true,
                ),
                const SizedBox(height: 8),
                const _FeedbackItem(
                  name: 'Alex Johnson',
                  time: '5h ago',
                  message: 'I\'m having trouble accessing the datasets for the week 3 project. The link seems to be broken or requires special permissions.',
                  isUnread: true,
                ),
                const SizedBox(height: 8),
                const _FeedbackItem(
                  name: 'Michael Ross',
                  time: '1d ago',
                  message: 'Great pace on the React hooks tutorial. I would love to see more examples focusing on custom hooks in the next section.',
                  isUnread: false,
                ),
                const SizedBox(height: 8),
                const _FeedbackItem(
                  name: 'Priya Lee',
                  time: '2d ago',
                  message: 'The guest lecture recording quality was a bit poor, making it hard to hear the Q&A session at the end. Otherwise, good content.',
                  isUnread: false,
                ),
              ],
            ),
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
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String initials;
  final String name;
  final String track;
  final double progress;
  final String progressText;

  const _ProgressRow({
    required this.initials,
    required this.name,
    required this.track,
    required this.progress,
    required this.progressText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFF3F5F8),
          child: Text(
            initials,
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                track,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFFF3F5F8),
                  color: _primaryBlue,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 32,
                child: Text(
                  progressText,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeedbackItem extends StatelessWidget {
  final String name;
  final String time;
  final String message;
  final bool isUnread;

  const _FeedbackItem({
    required this.name,
    required this.time,
    required this.message,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFFF8FAFD) : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: isUnread ? _primaryBlue : Colors.transparent,
            width: 4,
          ),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 13,
                  fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isUnread ? _textPrimary : _textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
