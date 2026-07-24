import 'package:flutter/material.dart';

import 'browse_programs_screen.dart';
import 'program_learning_screen.dart';
import '../services/enrollment_service.dart';
import '../widgets/program_application_form.dart';

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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ProgramApplicationForm(programTitle: widget.program.title),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final program = widget.program;

    return Scaffold(
      backgroundColor: _background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textSecondary),
          onPressed: () {
            Navigator.pop(context);
          },
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
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),

            children: [
              Container(
                height: 300,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black,

                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBRLMT7A6qJiQ7rlwVMobLypRC5k8PGCUDLi6H0-DOZ8qMy1O9ELxF2sQEx5eezFcaRyTV1iZ7DgzUIp5hJYUqljE5H5x1jNKxh3rUJrquSgg_9zPcr-eXPPeR2YrTQUhTgnN_CpUFY6QtMFQV0k-CJ0YkRoX2sxyDRMgEHmMsTNo-156JrGQ54LqhEWsnB6jFhMLlEV5J6tMF0_gYtRFwz-rh73MxxIQ3gppiMNJMknMOP4N1QeL3_BZ2Fwxs-xHOkUHMXJLDSeYQ',
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.6,
                  ),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(24),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),

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
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _DetailsCard(
                title: 'About the Program',

                child: Text(
                  '${program.description}\n\nMaster the fundamentals in this intensive program. Designed for aspiring professionals, this program covers practical skills through real-world projects and guided learning.',

                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _DetailsCard(
                title: "What You'll Learn",

                child: Column(
                  children: [
                    _LearnRow(
                      icon: Icons.psychology,
                      title: 'User Research',
                      desc: 'Conduct interviews and analyze user needs.',
                    ),

                    const SizedBox(height: 16),

                    _LearnRow(
                      icon: Icons.account_tree,
                      title: 'Wireframing',
                      desc: 'Create layouts and user experiences.',
                    ),

                    const SizedBox(height: 16),

                    _LearnRow(
                      icon: Icons.palette,
                      title: 'High-Fidelity Design',
                      desc: 'Apply visual design principles.',
                    ),

                    const SizedBox(height: 16),

                    _LearnRow(
                      icon: Icons.touch_app,
                      title: 'Prototyping',
                      desc: 'Build interactive prototypes.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _DetailsCard(
                title: 'Details',

                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.calendar_month,
                      label: 'Duration',
                      value: '8 Weeks',
                    ),

                    const Divider(height: 24),

                    _DetailRow(
                      icon: Icons.schedule,
                      label: 'Effort',
                      value: '15 hrs/week',
                    ),

                    const Divider(height: 24),

                    _DetailRow(
                      icon: Icons.school,
                      label: 'Level',
                      value: 'Beginner',
                    ),

                    const Divider(height: 24),

                    _DetailRow(
                      icon: Icons.language,
                      label: 'Format',
                      value: '100% Online',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _DetailsCard(
                title: 'Lead Instructor',

                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,

                      backgroundImage: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCAF_wOhdZzNBsN5VbuYGRdZEsu0Vv9ad5Ur6emGaQgxRGyIcyakSX9n7lv23nemkXPvBmWwaw0sRzQwQn6mQrE6WQkMxfM23E6l0ZBxuXTnpmr48LMuNxwlj5D5jiwxlX9a39k6ADV6BVbm70BVBKn0EgZ3DS4GZtHi1ScDdsZkFAivE-KYb2bRRDWE-zyJbc6XRhyqrAPDWDjwFpPdvewnrVkqzNBg25YnKtGx2gg-IrstdSBi7hljkXUoqdtsifaUUcA3-Tfvt8',
                      ),
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

                          const SizedBox(height: 4),

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

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

              color: Colors.white,

              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          widget.program.isSaved = !widget.program.isSaved;
                        });
                      },

                      child: Icon(
                        widget.program.isSaved
                            ? Icons.bookmark
                            : Icons.bookmark_border,

                        color: _primaryBlue,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    flex: 3,

                    child: ListenableBuilder(
                      listenable: EnrollmentService.instance,

                      builder: (context, child) {
                        final status = EnrollmentService.instance.getStatus(
                          widget.program.title,
                        );

                        return ElevatedButton(
                          onPressed: status == EnrollmentStatus.pending
                              ? null
                              : () {
                                  if (status == EnrollmentStatus.granted) {
                                    Navigator.push(
                                      context,

                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ProgramLearningScreen(),
                                      ),
                                    );
                                  } else {
                                    _showApplicationModal();
                                  }
                                },

                          child: Text(
                            status == EnrollmentStatus.pending
                                ? 'Under Review'
                                : status == EnrollmentStatus.granted
                                ? 'Continue'
                                : 'Apply Now',
                          ),
                        );
                      },
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

  const _LearnRow({
    required this.icon,

    required this.title,

    required this.desc,
  });

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

                style: const TextStyle(color: _textSecondary, fontSize: 13),
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

  const _DetailRow({
    required this.icon,

    required this.label,

    required this.value,
  });

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

              style: const TextStyle(color: _textSecondary, fontSize: 15),
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
