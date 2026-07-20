import 'package:flutter/material.dart';

import 'app_session.dart';
import 'browse_programs_screen.dart';
import 'program_details_screen.dart';

const Color _primaryBlue = Color(0xFF3F5BF6);
const Color _background = Color(0xFFF7F9FC);
const Color _textPrimary = Color(0xFF202533);
const Color _textSecondary = Color(0xFF7C8798);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> _programListingRoutes = <String>[
    '/program-listing',
    '/programs',
    '/browse',
    '/programListing',
    '/program-listing-screen',
  ];

  static const List<String> _programDetailsRoutes = <String>[
    '/program-details',
    '/program-detail',
    '/details',
    '/programDetails',
    '/program-details-screen',
  ];

  int _selectedIndex = 0;
  String _displayName = 'Alex';
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
      // Keep the safe fallback values if profile loading fails.
    }
  }

  String get _profileInitials {
    final List<String> words = _displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((String word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return 'U';
    }

    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }

    return '${words.first.substring(0, 1)}'
            '${words.last.substring(0, 1)}'
        .toUpperCase();
  }

  Future<bool> _pushFirstRegisteredRoute(
    List<String> routeNames, {
    required String screenLabel,
  }) async {
    for (final String routeName in routeNames) {
      try {
        final Future<dynamic> navigation =
            Navigator.of(context).pushNamed(routeName);
        await navigation;
        return true;
      } on FlutterError {
        // Try the next common route name.
      }
    }

    if (!mounted) {
      return false;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$screenLabel is available, but its route is not registered '
          'under any supported route name.',
        ),
      ),
    );
    return false;
  }

  Future<void> _openProgramListing() async {
    await _pushFirstRegisteredRoute(
      _programListingRoutes,
      screenLabel: 'Program Listing',
    );
  }

  Future<void> _openProgramDetails(ProgramData program) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProgramDetailsScreen(program: program),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _selectNavigationItem(int index) async {
    switch (index) {
      case 0:
        setState(() {
          _selectedIndex = 0;
        });
        return;
      case 1:
        setState(() {
          _selectedIndex = 1;
        });
        await _openProgramListing();
        if (mounted) {
          setState(() {
            _selectedIndex = 0;
          });
        }
        return;
      case 2:
        setState(() {
          _selectedIndex = 2;
        });
        await Navigator.of(context).pushNamed('/tasks');
        if (mounted) {
          setState(() {
            _selectedIndex = 0;
          });
        }
        return;
      case 3:
        await _openLearnerProfile();
        return;
    }
  }

  Future<void> _openLearnerProfile() async {
    final bool? shouldLogOut = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        final double bottomInset =
            MediaQuery.of(sheetContext).viewInsets.bottom;

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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
        children: [
          Text(
            'Hi, $_displayName!',
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Welcome back to your dashboard. You are making steady progress.',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),

          _DashboardCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Course Completion',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(
                      Icons.trending_up_rounded,
                      color: _primaryBlue,
                      size: 21,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Center(
                  child: SizedBox(
                    width: 132,
                    height: 132,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const SizedBox(
                          width: 132,
                          height: 132,
                          child: CircularProgressIndicator(
                            value: 0.75,
                            strokeWidth: 9,
                            backgroundColor: Color(0xFFE4E9FF),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(_primaryBlue),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '75%',
                              style: TextStyle(
                                color: _textPrimary,
                                fontSize: 31,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Completed',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'You are on track to complete the UX Engineering track by Nov 15.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          _DashboardCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Module',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                const _ModuleRow(
                  title: 'Wireframing Fundamentals',
                  status: 'IN PROGRESS',
                  active: true,
                ),
                const Divider(
                  height: 30,
                  color: Color(0xFFE7EAF0),
                ),
                const _ModuleRow(
                  title: 'Prototyping in Figma',
                  status: 'LOCKED',
                  active: false,
                ),
                const SizedBox(height: 22),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Resume Learning',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Saved Favorite Programs',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () async {
                  await _openProgramListing();
                  if (mounted) setState(() {});
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  minimumSize: const Size(0, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'VIEW ALL',
                  style: TextStyle(
                    color: _primaryBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          ...(() {
            final savedPrograms = ProgramData.samplePrograms
                .where((program) => program.isSaved)
                .toList();

            if (savedPrograms.isEmpty) {
              return [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'No saved programs yet.\nBrowse and save programs to see them here!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ];
            }

            return savedPrograms.map((program) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ProgramCard(
                  category: program.category,
                  arrangement: program.arrangement,
                  title: program.title,
                  description: program.description,
                  icon: program.icon,
                  isSaved: program.isSaved,
                  onTap: () => _openProgramDetails(program),
                ),
              );
            }).toList();
          })(),
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
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE5E9F0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ModuleRow extends StatelessWidget {
  const _ModuleRow({
    required this.title,
    required this.status,
    required this.active,
  });

  final String title;
  final String status;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: active ? _textPrimary : _textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFFE4E9FF)
                : const Color(0xFFF0F2F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: active ? _primaryBlue : const Color(0xFF9099A8),
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({
    required this.category,
    required this.arrangement,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSaved,
    required this.onTap,
  });

  final String category;
  final String arrangement;
  final String title;
  final String description;
  final IconData icon;
  final bool isSaved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE4E8EF),
            ),
          ),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 135,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE6EBFF),
                  Color(0xFFF4F6FC),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    icon,
                    size: 54,
                    color: _primaryBlue,
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: Colors.white,
                    child: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? _primaryBlue : const Color(0xFF7C8798),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _Tag(text: category),
                    const SizedBox(width: 8),
                    _Tag(text: arrangement),
                  ],
                ),
                const SizedBox(height: 11),
                Text(
                  title,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  description,
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F8),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF6E7888),
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}