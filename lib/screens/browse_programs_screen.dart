import 'package:flutter/material.dart';

import 'program_details_screen.dart';
import 'app_session.dart';
import '../widgets/notification_badge.dart';

const Color _primaryBlue = Color(0xFF3F5BF6);
const Color _background = Color(0xFFF7F9FC);
const Color _textPrimary = Color(0xFF202533);
const Color _textSecondary = Color(0xFF7C8798);

class ProgramData {
  final String category;
  final String arrangement;
  final String title;
  final String description;
  final IconData icon;
  final String company;
  final List<String> tags;
  bool isSaved;

  ProgramData({
    required this.category,
    required this.arrangement,
    required this.title,
    required this.description,
    required this.icon,
    required this.company,
    required this.tags,
    this.isSaved = false,
  });

  static final List<ProgramData> samplePrograms = [
    ProgramData(
      category: 'INTERNSHIP',
      arrangement: 'REMOTE',
      title: 'Frontend Developer Intern - React/Tailwind',
      description: 'Join our core UI engineering team to build scalable, accessible interfaces. You\'ll be working directly with senior designers and engineers on high-impact user-facing features using modern React patterns.',
      icon: Icons.corporate_fare,
      company: 'TechNova Solutions',
      tags: ['React', 'Tailwind CSS', 'Remote'],
    ),
    ProgramData(
      category: 'PROGRAM',
      arrangement: 'ONLINE',
      title: 'UX/UI Foundations Bootcamp',
      description: 'An intensive 8-week program covering user research, wireframing, high-fidelity design, and prototyping. Perfect for beginners looking to transition into product design roles.',
      icon: Icons.school,
      company: 'Nextern Academy',
      tags: ['Figma', 'Research', '8 Weeks'],
      isSaved: true,
    ),
    ProgramData(
      category: 'INTERNSHIP',
      arrangement: 'HYBRID',
      title: 'Junior Cloud Architect Intern',
      description: 'Assist in designing and deploying cloud infrastructure using AWS and Terraform. You will shadow senior architects and participate in optimizing CI/CD pipelines for enterprise clients.',
      icon: Icons.corporate_fare,
      company: 'CloudScale Inc.',
      tags: ['AWS', 'DevOps', 'Hybrid'],
    ),
    ProgramData(
      category: 'PROGRAM',
      arrangement: 'ONLINE',
      title: 'Full Stack Web Development',
      description: 'Learn to build complete web applications from scratch using Node.js, Express, and React.',
      icon: Icons.computer,
      company: 'CodeCraft Academy',
      tags: ['Node.js', 'React', 'Online'],
    ),
    ProgramData(
      category: 'INTERNSHIP',
      arrangement: 'REMOTE',
      title: 'Data Science Intern',
      description: 'Join our AI team to build predictive models and analyze large datasets using Python and TensorFlow.',
      icon: Icons.analytics,
      company: 'DataMinds',
      tags: ['Python', 'TensorFlow', 'Remote'],
      isSaved: true,
    ),
  ];
}

class BrowseProgramsScreen extends StatefulWidget {
  const BrowseProgramsScreen({super.key});

  @override
  State<BrowseProgramsScreen> createState() => _BrowseProgramsScreenState();
}

class _BrowseProgramsScreenState extends State<BrowseProgramsScreen> {
  int _selectedIndex = 1;
  String _displayName = 'Alex';

  String _searchQuery = '';
  String _activeFilter = 'All Categories';
  bool _showSavedOnly = false;
  int _visibleCount = 3;

  List<ProgramData> get _filteredPrograms {
    return ProgramData.samplePrograms.where((program) {
      if (_showSavedOnly && !program.isSaved) return false;
      if (_activeFilter != 'All Categories') {
        bool tagMatch = program.tags.any((tag) => tag.toLowerCase() == _activeFilter.toLowerCase());
        if (!tagMatch) return false;
      }
      
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = program.title.toLowerCase().contains(query);
        final matchesDesc = program.description.toLowerCase().contains(query);
        final matchesCompany = program.company.toLowerCase().contains(query);
        final matchesCategory = program.category.toLowerCase().contains(query);
        
        if (!matchesTitle && !matchesDesc && !matchesCompany && !matchesCategory) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  List<String> get _uniqueTags {
    final Set<String> tags = {};
    for (var program in ProgramData.samplePrograms) {
      tags.addAll(program.tags);
    }
    return tags.toList()..sort();
  }

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

  Future<void> _openFilterModal() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9DEE8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Filters',
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _activeFilter = 'All Categories';
                          });
                          setState(() {
                            _activeFilter = 'All Categories';
                            _visibleCount = 3;
                          });
                        },
                        child: const Text('Clear', style: TextStyle(color: _primaryBlue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Categories & Tags',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(
                        label: 'All Categories',
                        isSelected: _activeFilter == 'All Categories',
                        onTap: () {
                          setModalState(() => _activeFilter = 'All Categories');
                          setState(() {
                            _activeFilter = 'All Categories';
                            _visibleCount = 3;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ..._uniqueTags.map((tag) => _FilterChip(
                            label: tag,
                            isSelected: _activeFilter == tag,
                            onTap: () {
                              setModalState(() => _activeFilter = tag);
                              setState(() {
                                _activeFilter = tag;
                                _visibleCount = 3;
                              });
                              Navigator.pop(context);
                            },
                          )),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _selectNavigationItem(int index) async {
    if (index == _selectedIndex) return;

    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.settings.name == '/home');
    } else if (index == 2) {
      Navigator.of(context).pushReplacementNamed('/tasks');
    } else if (index == 3) {
      Navigator.of(context).pushReplacementNamed('/profile');
    }
  }

  Future<void> _openProgramDetails(ProgramData program) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProgramDetailsScreen(program: program),
      ),
    );
    if (mounted) setState(() {});
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
        children: [
          const Text(
            'Explore Opportunities',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Find internships and learning programs tailored to your skills.',
            style: TextStyle(
              color: _textSecondary,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          
          // Search Bar
          TextField(
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
                _visibleCount = 3;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search for programs, skills, or companies...',
              hintStyle: const TextStyle(color: _textSecondary),
              prefixIcon: const Icon(Icons.search_rounded, color: _textSecondary),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Color(0xFFE5E9F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Color(0xFFE5E9F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: _primaryBlue),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                InkWell(
                  onTap: _openFilterModal,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE5E9F0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.tune_rounded, size: 16, color: _textPrimary),
                        const SizedBox(width: 6),
                        Text(
                          _activeFilter == 'All Categories' ? 'Filters' : _activeFilter,
                          style: const TextStyle(
                            color: _textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Saved Programs',
                  isSelected: _showSavedOnly,
                  onTap: () {
                    setState(() {
                      _showSavedOnly = !_showSavedOnly; // Toggle saved independent of other filters
                      _visibleCount = 3;
                    });
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Remote',
                  isSelected: _activeFilter == 'Remote',
                  onTap: () {
                    setState(() {
                      _activeFilter = _activeFilter == 'Remote' ? 'All Categories' : 'Remote';
                      _visibleCount = 3;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Program Cards
          ...(() {
            final programs = _filteredPrograms;
            final visiblePrograms = programs.take(_visibleCount).toList();
            
            if (visiblePrograms.isEmpty) {
              return [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      'No programs found matching your criteria.',
                      style: TextStyle(color: _textSecondary),
                    ),
                  ),
                ),
              ];
            }
            
            return visiblePrograms.map((program) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ProgramListCard(
                    program: program,
                    onTap: () => _openProgramDetails(program),
                  ),
                )).toList();
          })(),
              
          if (_visibleCount < _filteredPrograms.length) ...[
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _visibleCount += 3;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: _textPrimary,
                  side: const BorderSide(color: Color(0xFFE5E9F0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Load More Opportunities'),
              ),
            )
          ]
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool hasDropdown;
  final VoidCallback? onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.hasDropdown = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _primaryBlue : const Color(0xFFE5E9F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : _textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (hasDropdown) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.expand_more,
                size: 16,
                color: isSelected ? Colors.white : _textSecondary,
              )
            ],
          ],
        ),
      ),
    );
  }
}

class _ProgramListCard extends StatelessWidget {
  final ProgramData program;
  final VoidCallback onTap;

  const _ProgramListCard({
    required this.program,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isProgram = program.category == 'PROGRAM';
    
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
            border: Border.all(color: const Color(0xFFE4E8EF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 135,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE6EBFF), Color(0xFFF4F6FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        isProgram ? Icons.school : Icons.cloud_outlined,
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
                          program.isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: program.isSaved ? _primaryBlue : _textSecondary,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(program.icon, size: 16, color: _textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              program.company,
                              style: const TextStyle(
                                color: _textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isProgram ? const Color(0xFFE8ECFF) : const Color(0xFFF0F2F5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            program.category,
                            style: TextStyle(
                              color: isProgram ? _primaryBlue : _textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      program.title,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      program.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: program.tags.map((tag) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F9FC),
                            border: Border.all(color: const Color(0xFFE5E9F0)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: _textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      )).toList(),
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
