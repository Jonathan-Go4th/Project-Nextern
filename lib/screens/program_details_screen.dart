import 'package:flutter/material.dart';

import 'browse_programs_screen.dart';
import 'program_learning_screen.dart';
import '../services/notification_service.dart';
import '../services/enrollment_service.dart';

const Color _primaryBlue = Color(0xFF3F5BF6);
const Color _background = Color(0xFFF7F9FC);
const Color _textPrimary = Color(0xFF202533);
const Color _textSecondary = Color(0xFF7C8798);

class ProgramDetailsScreen extends StatefulWidget {
  final ProgramData program;

  const ProgramDetailsScreen({super.key, required this.program});

  @override
  State<ProgramDetailsScreen> createState() => _ProgramDetailsScreenState();
}

class _ProgramDetailsScreenState extends State<ProgramDetailsScreen> {

  void _showApplicationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return _ApplicationFormModal(
          onSubmit: (reason) {
            EnrollmentService.instance.submitApplication(
              programTitle: widget.program.title,
              reason: reason,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final program = widget.program;
    bool isProgram = program.category == 'PROGRAM';

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textSecondary),
          onPressed: () => Navigator.of(context).pop(),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: _textSecondary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            children: [
              // Hero Section
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF181C1E),
                  image: const DecorationImage(
                    image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBRLMT7A6qJiQ7rlwVMobLypRC5k8PGCUDLi6H0-DOZ8qMy1O9ELxF2sQEx5eezFcaRyTV1iZ7DgzUIp5hJYUqljE5H5x1jNKxh3rUJrquSgg_9zPcr-eXPPeR2YrTQUhTgnN_CpUFY6QtMFQV0k-CJ0YkRoX2sxyDRMgEHmMsTNo-156JrGQ54LqhEWsnB6jFhMLlEV5J6tMF0_gYtRFwz-rh73MxxIQ3gppiMNJMknMOP4N1QeL3_BZ2Fwxs-xHOkUHMXJLDSeYQ'),
                    fit: BoxFit.cover,
                    opacity: 0.6,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _primaryBlue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              program.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            program.company,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        program.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // About
              _DetailsCard(
                title: 'About the Program',
                child: Text(
                  program.description + '\n\nMaster the fundamentals in this intensive program. Designed for aspiring professionals, this program covers the entire lifecycle—from research to high-fidelity prototyping and testing. You will build a comprehensive portfolio piece through hands-on, real-world project simulations.',
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // What You'll Learn
              _DetailsCard(
                title: "What You'll Learn",
                child: Column(
                  children: [
                    _LearnRow(icon: Icons.psychology, title: 'User Research', desc: 'Conduct interviews and analyze qualitative data.'),
                    const SizedBox(height: 16),
                    _LearnRow(icon: Icons.account_tree, title: 'Wireframing', desc: 'Create structural layouts and user flows.'),
                    const SizedBox(height: 16),
                    _LearnRow(icon: Icons.palette, title: 'High-Fidelity Design', desc: 'Apply typography, color theory, and visual hierarchy.'),
                    const SizedBox(height: 16),
                    _LearnRow(icon: Icons.touch_app, title: 'Prototyping', desc: 'Build interactive, testable mockups.'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Details
              _DetailsCard(
                title: 'Details',
                child: Column(
                  children: [
                    _DetailRow(icon: Icons.calendar_month, label: 'Duration', value: program.tags.length > 2 ? program.tags[2] : '8 Weeks'),
                    const Divider(color: Color(0xFFE5E9F0), height: 24),
                    _DetailRow(icon: Icons.schedule, label: 'Effort', value: '15 hrs/week'),
                    const Divider(color: Color(0xFFE5E9F0), height: 24),
                    _DetailRow(icon: Icons.school, label: 'Level', value: 'Beginner'),
                    const Divider(color: Color(0xFFE5E9F0), height: 24),
                    _DetailRow(icon: Icons.language, label: 'Format', value: '100% Online'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Lead Instructor
              _DetailsCard(
                title: 'Lead Instructor',
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCAF_wOhdZzNBsN5VbuYGRdZEsu0Vv9ad5Ur6emGaQgxRGyIcyakSX9n7lv23nemkXPvBmWwaw0sRzQwQn6mQrE6WQkMxfM23E6l0ZBxuXTnpmr48LMuNxwlj5D5jiwxlX9a39k6ADV6BVbm70BVBKn0EgZ3DS4GZtHi1ScDdsZkFAivE-KYb2bRRDWE-zyJbc6XRhyqrAPDWDjwFpPdvewnrVkqzNBg25YnKtGx2gg-IrstdSBi7hljkXUoqdtsifaUUcA3-Tfvt8'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sarah Jenkins',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Senior Product Designer @ ${program.company}',
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
              ),
            ],
          ),

          // Sticky Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                border: const Border(
                  top: BorderSide(color: Color(0xFFE5E9F0)),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          widget.program.isSaved = !widget.program.isSaved;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              widget.program.isSaved
                                  ? 'Program saved to favorites'
                                  : 'Program removed from favorites',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFE5E9F0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Icon(
                        widget.program.isSaved
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: widget.program.isSaved
                            ? _primaryBlue
                            : _textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: ListenableBuilder(
                      listenable: EnrollmentService.instance,
                      builder: (context, child) {
                        final _enrollmentStatus = EnrollmentService.instance.getStatus(widget.program.title);
                        return ElevatedButton(
                          onPressed: _enrollmentStatus == EnrollmentStatus.pending
                              ? null
                              : () {
                                  if (_enrollmentStatus == EnrollmentStatus.granted) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const ProgramLearningScreen(),
                                      ),
                                    );
                                  } else {
                                    _showApplicationModal();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _enrollmentStatus == EnrollmentStatus.pending
                                ? const Color(0xFFFFF9E6)
                                : _primaryBlue,
                            foregroundColor: _enrollmentStatus == EnrollmentStatus.pending
                                ? const Color(0xFFF59E0B)
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: _enrollmentStatus == EnrollmentStatus.pending
                                  ? const BorderSide(color: Color(0xFFFCD34D))
                                  : BorderSide.none,
                            ),
                          ),
                          child: _enrollmentStatus == EnrollmentStatus.pending
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.access_time, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      'Under Review',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  _enrollmentStatus == EnrollmentStatus.granted
                                      ? 'Continue'
                                      : 'Apply Now',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailsCard({required this.title, required this.child});

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
          Text(
            title,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _LearnRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _LearnRow({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _primaryBlue, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: _textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 15,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ApplicationFormModal extends StatefulWidget {
  final ValueChanged<String> onSubmit;

  const _ApplicationFormModal({required this.onSubmit});

  @override
  State<_ApplicationFormModal> createState() => _ApplicationFormModalState();
}

class _ApplicationFormModalState extends State<_ApplicationFormModal> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _portfolioController = TextEditingController();
  String _selectedExperience = 'Entry-level';

  @override
  void dispose() {
    _reasonController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a reason for joining.')),
      );
      return;
    }
    Navigator.pop(context);
    widget.onSubmit(_reasonController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Application Form', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: _textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Experience Level', style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedExperience,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: ['Student', 'Entry-level', 'Mid-level', 'Senior-level']
                .map((exp) => DropdownMenuItem(value: exp, child: Text(exp)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedExperience = val);
            },
          ),
          const SizedBox(height: 16),
          const Text('Reason for joining', style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _reasonController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Why do you want to join this program?',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Portfolio / LinkedIn Profile (Optional)', style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: _portfolioController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.link),
              hintText: 'https://...',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryBlue,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Submit Application', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
