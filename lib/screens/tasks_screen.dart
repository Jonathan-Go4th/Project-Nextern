import 'package:flutter/material.dart';
import 'app_session.dart';

const Color _primaryBlue = Color(0xFF3F5BF6);
const Color _background = Color(0xFFF7F9FC);
const Color _textPrimary = Color(0xFF202533);
const Color _textSecondary = Color(0xFF7C8798);

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 2;
  String _displayName = 'Alex';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile handled by Home screen.')),
      );
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
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF3C4554),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: const Text(
              'Learning Hub',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 27,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: _primaryBlue,
            unselectedLabelColor: _textSecondary,
            indicatorColor: _primaryBlue,
            labelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: 'Assignments'),
              Tab(text: 'Certificates'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Assignments Tab
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: const [
                    _AssignmentCard(
                      category: 'UI/UX Design',
                      dueStatus: 'Due: Today',
                      isDueSoon: true,
                      title: 'Wireframe Prototype',
                      description: 'Design a low-fidelity interactive prototype for the main user dashboard following the new design system.',
                      buttonText: 'Submit Assignment',
                      buttonColor: _primaryBlue,
                      buttonTextColor: Colors.white,
                    ),
                    SizedBox(height: 16),
                    _AssignmentCard(
                      category: 'Frontend Dev',
                      dueStatus: 'Due: In 2 Days',
                      isDueSoon: false,
                      title: 'Component Library setup',
                      description: 'Initialize the React component library structure and implement the base Typography and Button components.',
                      buttonText: 'Submit Assignment',
                      buttonColor: _primaryBlue,
                      buttonTextColor: Colors.white,
                    ),
                    SizedBox(height: 16),
                    _AssignmentCard(
                      category: 'Data Analysis',
                      dueStatus: 'Submitted',
                      isDueSoon: false,
                      title: 'SQL Query Optimization',
                      description: 'Review and optimize the provided legacy queries to improve execution time by at least 30%.',
                      buttonText: 'Under Review',
                      buttonColor: Color(0xFFF0F2F5),
                      buttonTextColor: _textSecondary,
                    ),
                  ],
                ),
                // Certificates Tab
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: const [
                    _CertificateCard(
                      title: 'Foundations of Product Design',
                      date: 'Completed on Oct 12, 2023',
                    ),
                    SizedBox(height: 16),
                    _CertificateCard(
                      title: 'Agile Methodology Sprint',
                      date: 'Completed on Aug 05, 2023',
                    ),
                  ],
                ),
              ],
            ),
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
}

class _AssignmentCard extends StatelessWidget {
  final String category;
  final String dueStatus;
  final bool isDueSoon;
  final String title;
  final String description;
  final String buttonText;
  final Color buttonColor;
  final Color buttonTextColor;

  const _AssignmentCard({
    required this.category,
    required this.dueStatus,
    required this.isDueSoon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.buttonColor,
    required this.buttonTextColor,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                dueStatus,
                style: TextStyle(
                  color: isDueSoon ? const Color(0xFFD32F2F) : _textSecondary,
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
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final String title;
  final String date;

  const _CertificateCard({
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
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: _primaryBlue,
              size: 32,
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
          IconButton(
            onPressed: () {},
            style: IconButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE5E9F0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(
              Icons.download_rounded,
              color: _primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
