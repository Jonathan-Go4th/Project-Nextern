import 'package:flutter/material.dart';
import '../widgets/notification_badge.dart';
import '../widgets/logout_confirmation_dialog.dart';
import '../models/certificate.dart';
import '../services/certificate_store.dart';
import '../widgets/certificate_viewer_dialog.dart';
import 'app_session.dart';
import 'program_learning_screen.dart';

const Color _primaryBlue = Color(0xFF3F5BF6);
const Color _background = Color(0xFFF7F9FC);
const Color _textPrimary = Color(0xFF202533);
const Color _textSecondary = Color(0xFF7C8798);

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _displayName = 'Alex';
  String _email = '';
  int _selectedTab = 0; // 0 for Active, 1 for Completed

  final List<Map<String, dynamic>> _activePrograms = [
    {'title': 'UX Engineering Track', 'completion': 0.33, 'dueDate': 'Due in 3 days', 'tag': 'Design'},
    {'title': 'Flutter Fundamentals', 'completion': 0.15, 'dueDate': 'Due in 1 week', 'tag': 'Mobile'},
    {'title': 'Advanced Prototyping', 'completion': 0.80, 'dueDate': 'Due tomorrow', 'tag': 'Design'},
    {'title': 'State Management in Flutter', 'completion': 0.05, 'dueDate': 'Due in 2 weeks', 'tag': 'Mobile'},
    {'title': 'Backend APIs with Node.js', 'completion': 0.50, 'dueDate': 'Due in 5 days', 'tag': 'Web'},
    {'title': 'React Component Design', 'completion': 0.20, 'dueDate': 'Due in 10 days', 'tag': 'Web'},
  ];

  final List<Map<String, dynamic>> _completedPrograms = [
    {'title': 'Foundations of Product Design', 'date': 'Completed on Oct 12, 2023'},
    {'title': 'Agile Methodology Sprint', 'date': 'Completed on Aug 05, 2023'},
    {'title': 'Intro to UI Design', 'date': 'Completed on Jan 22, 2023'},
    {'title': 'Design Thinking Process', 'date': 'Completed on Nov 10, 2022'},
    {'title': 'Figma Basics', 'date': 'Completed on Sep 15, 2022'},
    {'title': 'Wireframing Principles', 'date': 'Completed on Jul 01, 2022'},
  ];

  int _visibleActiveCount = 3;
  int _visibleCompletedCount = 3;
  bool _isLoadingMore = false;

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

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _isLoadingMore = false;
      if (_selectedTab == 0) {
        _visibleActiveCount = _activePrograms.length;
      } else {
        _visibleCompletedCount = _completedPrograms.length;
      }
    });
  }

  Future<void> _openLearnerProfile() async {
    final bool? shouldLogOut = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        final double bottomInset = MediaQuery.of(
          sheetContext,
        ).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SafeArea(
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
                    style: const TextStyle(color: _textSecondary, fontSize: 13),
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
                      border: Border.all(color: const Color(0xFFE5E9F0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.school_outlined,
                          color: _primaryBlue,
                          size: 21,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Learner account',
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
                      onPressed: () async {
                        final bool confirmed =
                            await showLogoutConfirmationDialog(sheetContext);
                        if (confirmed && sheetContext.mounted) {
                          Navigator.of(sheetContext).pop(true);
                        }
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
          ),
        );
      },
    );

    if (shouldLogOut != true) {
      return;
    }

    try {
      await AppSession.logOut();
    } catch (_) {}

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
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leadingWidth: 62,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: IconButton(
            tooltip: 'Learner profile',
            onPressed: _openLearnerProfile,
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/nextern_logo.png',
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 0.5),
            const Text(
              'NEXTERN',
              style: TextStyle(
                color: _primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.7,
              ),
            ),
          ],
        ),




        centerTitle: true,
        actions: [
          const NotificationBadge(iconColor: Color(0xFF3C4554)),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Text(
              'My Learning',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 27,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _buildSegmentedControl(),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedTab == 0 ? _buildActiveList() : _buildCompletedList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFE5E9F0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = 0),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _selectedTab == 0 ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: _selectedTab == 0
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      'Enrolled',
                      style: TextStyle(
                        color: _selectedTab == 0 ? _textPrimary : _textSecondary,
                        fontWeight: _selectedTab == 0 ? FontWeight.w700 : FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = 1),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _selectedTab == 1 ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: _selectedTab == 1
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      'Completed',
                      style: TextStyle(
                        color: _selectedTab == 1 ? _textPrimary : _textSecondary,
                        fontWeight: _selectedTab == 1 ? FontWeight.w700 : FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveList() {
    final count = _visibleActiveCount;
    final total = _activePrograms.length;
    final hasMore = count < total;

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: count + (hasMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == count) {
          return _buildLoadMoreButton();
        }
        final item = _activePrograms[index];
        return _ActiveCourseCard(
          title: item['title'],
          completion: item['completion'],
          dueDate: item['dueDate'],
          tag: item['tag'],
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ProgramLearningScreen(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCompletedList() {
    return ListenableBuilder(
      listenable: CertificateStore.instance,
      builder: (context, _) {
        final certs = CertificateStore.instance.certificates;

        if (certs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'No completed courses or certificates yet.\nComplete all program tasks to earn your certificates!',
                textAlign: TextAlign.center,
                style: TextStyle(color: _textSecondary, height: 1.5),
              ),
            ),
          );
        }

        final count = _visibleCompletedCount < certs.length ? _visibleCompletedCount : certs.length;
        final hasMore = count < certs.length;

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: count + (hasMore ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            if (index == count) {
              return _buildLoadMoreButton();
            }
            final cert = certs[index];
            return _CompletedCourseCard(
              certificate: cert,
            );
          },
        );
      },
    );
  }

  Widget _buildLoadMoreButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: _isLoadingMore
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_primaryBlue),
              )
            : TextButton(
                onPressed: _loadMore,
                style: TextButton.styleFrom(
                  foregroundColor: _primaryBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFFE5E9F0)),
                  ),
                ),
                child: const Text(
                  'Load More',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
      ),
    );
  }
}

class _ActiveCourseCard extends StatelessWidget {
  final String title;
  final double completion;
  final String dueDate;
  final String tag;
  final VoidCallback onTap;

  const _ActiveCourseCard({
    required this.title,
    required this.completion,
    required this.dueDate,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E9F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  dueDate,
                  style: const TextStyle(
                    color: Color(0xFFD32F2F),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: completion,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFE4E9FF),
                      valueColor: const AlwaysStoppedAnimation<Color>(_primaryBlue),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${(completion * 100).toInt()}%',
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedCourseCard extends StatelessWidget {
  final Certificate certificate;

  const _CompletedCourseCard({
    required this.certificate,
  });

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E9F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Color(0xFF43A047),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      certificate.programTitle,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Completed on ${_formatDate(certificate.issueDate)} • ${certificate.recipientName}',
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CertificateViewerDialog(certificate: certificate),
                    );
                  },
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                  label: const Text('View Cert'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primaryBlue,
                    side: const BorderSide(color: _primaryBlue),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.download_done_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text('Downloaded "${certificate.programTitle}" Certificate (ID: ${certificate.verificationCode})'),
                            ),
                          ],
                        ),
                        backgroundColor: const Color(0xFF43A047),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text('Download'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
