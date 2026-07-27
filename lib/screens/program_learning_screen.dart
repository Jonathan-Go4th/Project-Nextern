import 'package:flutter/material.dart';

import '../widgets/notification_badge.dart';
import 'content_viewer_screen.dart';

const Color _primaryBlue = Color(0xFF3F5BF6);
const Color _background = Color(0xFFF7F9FC);
const Color _textPrimary = Color(0xFF202533);
const Color _textSecondary = Color(0xFF7C8798);

class ProgramLearningScreen extends StatefulWidget {
  const ProgramLearningScreen({super.key});

  @override
  State<ProgramLearningScreen> createState() => _ProgramLearningScreenState();
}

class _ProgramLearningScreenState extends State<ProgramLearningScreen> {
  final List<Map<String, dynamic>> _weeks = [
    {
      'title': 'Week 1: Introduction to UX Engineering',
      'contents': [
        {'type': 'video', 'title': 'Welcome to the Course', 'duration': '5 mins', 'isCompleted': true},
        {'type': 'pdf', 'title': 'Syllabus & Guidelines', 'duration': '10 mins', 'isCompleted': true},
        {'type': 'video', 'title': 'What is UX Engineering?', 'duration': '15 mins', 'isCompleted': true},
      ],
      'assignment': {
        'title': 'Course Setup & Intro',
        'dueDate': 'Submitted',
        'isSubmitted': true,
        'uploadedFiles': ['Setup_Screenshot.png'],
      }
    },
    {
      'title': 'Week 2: Wireframing Fundamentals',
      'contents': [
        {'type': 'video', 'title': 'The Importance of Wireframes', 'duration': '12 mins', 'isCompleted': true},
        {'type': 'interactive', 'title': 'Figma Basics Exercise', 'duration': '30 mins', 'isCompleted': false},
        {'type': 'video', 'title': 'Layout & Grid Systems', 'duration': '18 mins', 'isCompleted': false},
      ],
      'assignment': {
        'title': 'Midterm UI Prototype',
        'dueDate': 'Due Oct 30, 11:59 PM',
        'isSubmitted': false,
        'uploadedFiles': [],
      }
    },
    {
      'title': 'Week 3: Advanced Prototyping',
      'contents': [
        {'type': 'video', 'title': 'Interactive Components', 'duration': '20 mins', 'isCompleted': false},
        {'type': 'pdf', 'title': 'Animation Guidelines', 'duration': '15 mins', 'isCompleted': false},
      ],
      'assignment': {
        'title': 'Micro-interactions Assignment',
        'dueDate': 'Due Nov 06, 11:59 PM',
        'isSubmitted': false,
        'uploadedFiles': [],
      }
    }
  ];

  double _getOverallProgress() {
    int totalItems = 0;
    int completedItems = 0;

    for (var week in _weeks) {
      final List<dynamic> contents = week['contents'];
      final Map<String, dynamic> assignment = week['assignment'];

      totalItems += contents.length + 1; // +1 for assignment

      for (var content in contents) {
        if (content['isCompleted'] == true) {
          completedItems++;
        }
      }
      if (assignment['isSubmitted'] == true) {
        completedItems++;
      }
    }

    if (totalItems == 0) return 0;
    return completedItems / totalItems;
  }

  @override
  Widget build(BuildContext context) {
    final double overallProgress = _getOverallProgress();

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.95),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Learning Hub',
          style: TextStyle(
            color: _primaryBlue,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.7,
          ),
        ),
        actions: const [
          NotificationBadge(iconColor: _textSecondary),
          SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE5E9F0))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8ECFF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PROGRAM',
                        style: TextStyle(
                          color: _primaryBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'UX Engineering Track',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Master the fundamentals of UX engineering. This comprehensive program covers user research, wireframing, and high-fidelity prototyping using industry-standard tools.',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                // Progress Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Overall Progress',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${(overallProgress * 100).toInt()}%',
                      style: const TextStyle(
                        color: _primaryBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: overallProgress,
                    backgroundColor: const Color(0xFFE5E9F0),
                    color: _primaryBlue,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Weekly Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Course Curriculum',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                ..._weeks.map((week) => _buildWeekTile(week)).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekTile(Map<String, dynamic> week) {
    final List<dynamic> contents = week['contents'];
    final Map<String, dynamic> assignment = week['assignment'];

    int totalItems = contents.length + 1;
    int completedItems = 0;
    for (var content in contents) {
      if (content['isCompleted'] == true) {
        completedItems++;
      }
    }
    if (assignment['isSubmitted'] == true) {
      completedItems++;
    }

    double percent = completedItems / totalItems;
    bool isFullyCompleted = percent == 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E9F0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: week['title'].contains('Week 2'), // Auto expand current week
          iconColor: _primaryBlue,
          collapsedIconColor: _textSecondary,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Row(
            children: [
              // Completion Pill
              Container(
                margin: const EdgeInsets.only(right: 12),
                width: 38,
                height: 38,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: percent,
                      backgroundColor: const Color(0xFFE8ECFF),
                      color: isFullyCompleted ? const Color(0xFF4CAF50) : _primaryBlue,
                      strokeWidth: 3,
                    ),
                    if (isFullyCompleted)
                      const Icon(Icons.check, color: Color(0xFF4CAF50), size: 18)
                    else
                      Text(
                        '${(percent * 100).toInt()}%',
                        style: TextStyle(
                          color: percent > 0 ? _primaryBlue : _textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  week['title'],
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 15,
                    fontWeight: isFullyCompleted ? FontWeight.w600 : FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          children: [
            const Divider(color: Color(0xFFE5E9F0), height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Learning Materials
                  const Text(
                    'Learning Materials',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...contents.map((item) => _buildContentItem(item)).toList(),
                  
                  const SizedBox(height: 24),
                  
                  // Assignment Dropbox
                  const Text(
                    'Weekly Assignment',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAssignmentDropbox(assignment),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentItem(Map<String, dynamic> item) {
    IconData icon;
    Color iconColor;
    
    switch (item['type']) {
      case 'video':
        icon = Icons.play_circle_fill_rounded;
        iconColor = const Color(0xFFE53935);
        break;
      case 'pdf':
        icon = Icons.picture_as_pdf_rounded;
        iconColor = const Color(0xFF43A047);
        break;
      case 'interactive':
      default:
        icon = Icons.touch_app_rounded;
        iconColor = const Color(0xFFFFA000);
        break;
    }

    bool isCompleted = item['isCompleted'] == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ContentViewerScreen(
                      title: item['title'],
                      type: item['type'],
                      duration: item['duration'],
                    ),
                  ),
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: TextStyle(
                      color: isCompleted ? _textSecondary : _textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['duration'],
                    style: const TextStyle(
                      color: _textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                item['isCompleted'] = !isCompleted;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? const Color(0xFF4CAF50) : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? const Color(0xFF4CAF50) : const Color(0xFFC5CEE0),
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentDropbox(Map<String, dynamic> assignment) {
    final bool isSubmitted = assignment['isSubmitted'];
    final List<dynamic> uploadedFiles = assignment['uploadedFiles'] ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E9F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  assignment['title'],
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isSubmitted ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  assignment['dueDate'],
                  style: TextStyle(
                    color: isSubmitted ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (isSubmitted)
            Row(
              children: [
                const Icon(Icons.task_alt, color: Color(0xFF4CAF50), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Assignment submitted successfully.',
                  style: TextStyle(color: _textSecondary, fontSize: 13),
                ),
              ],
            )
          else
            Column(
              children: [
                if (uploadedFiles.isNotEmpty)
                  ...uploadedFiles.map((file) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFC5CEE0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file, color: _primaryBlue, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            file.toString(),
                            style: const TextStyle(
                              color: _textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Color(0xFFE53935), size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              uploadedFiles.remove(file);
                            });
                          },
                        ),
                      ],
                    ),
                  )).toList()
                else
                  InkWell(
                    onTap: () async {
                      // Mock showing a snackbar then adding file
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Selecting file...'), duration: Duration(milliseconds: 500)),
                      );
                      await Future.delayed(const Duration(milliseconds: 600));
                      if (!mounted) return;
                      setState(() {
                        assignment['uploadedFiles'] = ['My_Assignment_Prototype.fig'];
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFC5CEE0),
                          width: 1.5,
                          style: BorderStyle.solid, 
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.cloud_upload_outlined, color: _primaryBlue, size: 32),
                          const SizedBox(height: 8),
                          const Text(
                            'Tap to browse or drag file here',
                            style: TextStyle(color: _textSecondary, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Max size: 50MB (.pdf, .zip, .fig)',
                            style: TextStyle(color: Color(0xFFA0AABF), fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: uploadedFiles.isEmpty
                        ? null
                        : () {
                            setState(() {
                              assignment['isSubmitted'] = true;
                              assignment['dueDate'] = 'Submitted';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Assignment submitted successfully!'),
                                backgroundColor: Color(0xFF4CAF50),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: uploadedFiles.isEmpty ? const Color(0xFFE5E9F0) : _primaryBlue,
                      foregroundColor: uploadedFiles.isEmpty ? _textSecondary : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Submit Assignment',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
