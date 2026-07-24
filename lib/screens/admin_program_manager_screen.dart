import 'package:flutter/material.dart';
import '../widgets/notification_badge.dart';
import 'app_session.dart';
import 'admin_program_maker_screen.dart';
import 'admin_program_submissions_screen.dart';
import 'admin_user_management_screen.dart';

const Color _primaryBlue = Color(0xFF3157F6);
const Color _background = Color(0xFFF8FAFD);
const Color _textPrimary = Color(0xFF202532);
const Color _textSecondary = Color(0xFF788394);
const Color _border = Color(0xFFE2E7EF);

class AdminProgramManagerScreen extends StatefulWidget {
  const AdminProgramManagerScreen({super.key});

  @override
  State<AdminProgramManagerScreen> createState() => _AdminProgramManagerScreenState();
}

class _AdminProgramManagerScreenState extends State<AdminProgramManagerScreen> {
  int _selectedIndex = 1;
  String _displayName = 'Administrator';
  String _email = '';

  int _visibleCount = 3;
  
  List<Map<String, dynamic>> _programs = [
    {'title': 'Data Analysis Fundamentals', 'desc': 'Learn the basics of data analysis using Python.', 'learners': 120, 'dateRange': 'Oct 12 - Nov 12'},
    {'title': 'UX Wireframing', 'desc': 'Master Figma and user experience design principles.', 'learners': 85, 'dateRange': 'Oct 15 - Nov 5'},
    {'title': 'React Architecture', 'desc': 'Advanced component patterns for React applications.', 'learners': 42, 'dateRange': 'Nov 1 - Dec 15'},
    {'title': 'Flutter Masterclass', 'desc': 'Build cross-platform mobile apps with Flutter.', 'learners': 215, 'dateRange': 'Nov 10 - Jan 10'},
    {'title': 'Node.js Backend Basics', 'desc': 'Introduction to server-side JS and APIs.', 'learners': 90, 'dateRange': 'Dec 1 - Jan 5'},
    {'title': 'Machine Learning 101', 'desc': 'Understand the core concepts of ML and AI.', 'learners': 310, 'dateRange': 'Jan 15 - Mar 25'},
  ];

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
    final List<String> words = _displayName.trim().split(RegExp(r'\s+')).where((String word) => word.isNotEmpty).toList();
    if (words.isEmpty) return 'A';
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
    return '${words.first.substring(0, 1)}${words.last.substring(0, 1)}'.toUpperCase();
  }

  void _handleNavigation(int index) {
    if (index == _selectedIndex) return;
    
    if (index == 0) {
      Navigator.of(context).pushReplacementNamed('/admin-home');
    } else if (index == 2) {
      Navigator.of(context).pushReplacementNamed('/admin-user-management');
    } else if (index == 3) {
      Navigator.of(context).pushReplacementNamed('/admin-profile');
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
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 42, height: 4, decoration: BoxDecoration(color: const Color(0xFFD9DEE8), borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 26),
                CircleAvatar(radius: 44, backgroundColor: const Color(0xFFE8ECFF), child: Text(_profileInitials, style: const TextStyle(color: _primaryBlue, fontSize: 28, fontWeight: FontWeight.w800))),
                const SizedBox(height: 16),
                Text(_displayName, textAlign: TextAlign.center, style: const TextStyle(color: _textPrimary, fontSize: 21, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(_email.isEmpty ? 'Email will appear after your next login' : _email, textAlign: TextAlign.center, style: const TextStyle(color: _textSecondary, fontSize: 13)),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(sheetContext).pop(true),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Log out'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD32F2F),
                      side: const BorderSide(color: Color(0xFFFFCDD2)),
                      backgroundColor: const Color(0xFFFFF7F7),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldLogOut == true) {
      try {
        await AppSession.logOut();
        if (mounted) Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      } catch (_) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to clear the saved login session.')));
      }
    }
  }

  void _deleteProgram(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Program'),
          content: Text('Are you sure you want to delete "${_programs[index]['title']}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                setState(() => _programs.removeAt(index));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Program deleted.')));
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
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
                child: Text(_profileInitials, style: const TextStyle(color: _primaryBlue, fontSize: 13, fontWeight: FontWeight.w800)),
              ),
            ),
          ),
          title: const Text('PROGRAM MANAGER', style: TextStyle(color: _primaryBlue, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 0.7)),
          centerTitle: true,
          actions: const [
            NotificationBadge(iconColor: Color(0xFF414958)),
            SizedBox(width: 7),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search programs...',
                  prefixIcon: const Icon(Icons.search, color: _textSecondary),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: _visibleCount < _programs.length ? _visibleCount + 1 : _programs.length,
                itemBuilder: (context, index) {
                  if (index == _visibleCount && _visibleCount < _programs.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _visibleCount += 3;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primaryBlue,
                          side: const BorderSide(color: _primaryBlue),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Load More Programs', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    );
                  }

                  final program = _programs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminProgramSubmissionsScreen(program: program)));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(program['title'], style: const TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminProgramMakerScreen(initialProgram: program)));
                                  } else if (value == 'delete') {
                                    _deleteProgram(index);
                                  }
                                },
                                itemBuilder: (BuildContext context) => [
                                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                  const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(program['desc'], style: const TextStyle(color: _textSecondary, fontSize: 13)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(Icons.people, size: 16, color: _primaryBlue),
                              const SizedBox(width: 4),
                              Text('${program['learners']} Learners', style: const TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                              const SizedBox(width: 16),
                              const Icon(Icons.calendar_today, size: 16, color: _primaryBlue),
                              const SizedBox(width: 4),
                              Text(program['dateRange'] ?? program['duration'] ?? '', style: const TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AdminProgramMakerScreen()));
          },
          backgroundColor: _primaryBlue,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _handleNavigation,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: _primaryBlue,
          unselectedItemColor: const Color(0xFF8A94A4),
          selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), activeIcon: Icon(Icons.menu_book), label: 'Programs'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
        ),
      ),
    );
  }
}
