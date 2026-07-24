import 'package:flutter/material.dart';
import '../widgets/notification_badge.dart';
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
  int _selectedIndex = 2;
  String _displayName = 'Alex';
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
      Navigator.of(context).popUntil((route) => route.settings.name == '/home');
    } else if (index == 1) {
      Navigator.of(context).pushReplacementNamed('/browse');
    } else if (index == 3) {
      Navigator.of(context).pushReplacementNamed('/profile');
    }
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
          child: Center(
            child: CircleAvatar(
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
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.7,
          ),
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
    final count = _visibleCompletedCount;
    final total = _completedPrograms.length;
    final hasMore = count < total;

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: count + (hasMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == count) {
          return _buildLoadMoreButton();
        }
        final item = _completedPrograms[index];
        return _CompletedCourseCard(
          title: item['title'],
          date: item['date'],
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
  final String title;
  final String date;

  const _CompletedCourseCard({
    required this.title,
    required this.date,
  });

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
                      title,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading Certificate...')),
                );
              },
              icon: const Icon(Icons.download_rounded, size: 20),
              label: const Text('Download Certificate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
