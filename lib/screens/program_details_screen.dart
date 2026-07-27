import 'package:flutter/material.dart';

import '../models/program.dart';
import '../services/program_store.dart';
import 'program_learning_screen.dart';
import '../services/enrollment_service.dart';
import '../widgets/program_application_form.dart';

const Color _primaryBlue = Color(0xFF3F5BF6);
const Color _background = Color(0xFFF7F9FC);
const Color _textPrimary = Color(0xFF202533);
const Color _textSecondary = Color(0xFF7C8798);

class ProgramDetailsScreen extends StatefulWidget {
  final Program program;

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
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
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
                  gradient: program.imageUrl == null
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF3F5BF6), Color(0xFF181C1E)],
                        )
                      : null,
                  color: const Color(0xFF181C1E),
                  image: program.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(program.imageUrl!),
                          fit: BoxFit.cover,
                          opacity: 0.6,
                          onError: (exception, stackTrace) {},
                        )
                      : null,
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
                  program.fullDescription,
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
                child: program.learningOutcomes.isEmpty
                    ? const Text(
                        'Learning outcomes for this program will be shared soon.',
                        style: TextStyle(color: _textSecondary, fontSize: 14),
                      )
                    : Column(
                        children: [
                          for (var i = 0; i < program.learningOutcomes.length; i++) ...[
                            if (i > 0) const SizedBox(height: 16),
                            _LearnRow(
                              icon: _learnIconFor(i),
                              title: program.learningOutcomes[i],
                            ),
                          ],
                        ],
                      ),
              ),

              const SizedBox(height: 16),

              _DetailsCard(
                title: 'Details',

                child: Column(
                  children: [
                    _DetailRow(icon: Icons.calendar_month, label: 'Duration', value: program.duration ?? 'N/A'),
                    const Divider(color: Color(0xFFE5E9F0), height: 24),
                    _DetailRow(icon: Icons.schedule, label: 'Effort', value: program.effort ?? 'N/A'),
                    const Divider(color: Color(0xFFE5E9F0), height: 24),
                    _DetailRow(icon: Icons.school, label: 'Level', value: program.level ?? 'N/A'),
                    const Divider(color: Color(0xFFE5E9F0), height: 24),
                    _DetailRow(icon: Icons.language, label: 'Format', value: program.format ?? 'N/A'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Lead Instructor
              if (program.instructorName != null)
                _DetailsCard(
                  title: 'Lead Instructor',
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFFE5E9F0),
                        child: Text(
                          program.instructorName!.isNotEmpty
                              ? program.instructorName![0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: _primaryBlue,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              program.instructorName!,
                              style: const TextStyle(
                                color: _textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              program.instructorRole != null
                                  ? '${program.instructorRole} @ ${program.company}'
                                  : program.company,
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
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
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
                    child: ListenableBuilder(
                      listenable: ProgramStore.instance,
                      builder: (context, child) {
                        final isSaved = ProgramStore.instance.savedProgramIds.contains(program.id);
                        return OutlinedButton(
                          onPressed: () {
                            ProgramStore.instance.toggleSaved(program.id);
                            final nowSaved = ProgramStore.instance.savedProgramIds.contains(program.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  nowSaved
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
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved ? _primaryBlue : _textSecondary,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    flex: 3,

                    child: ListenableBuilder(
                      listenable: EnrollmentService.instance,

                      builder: (context, child) {
                        final enrollmentStatus = EnrollmentService.instance.getStatus(widget.program.title);
                        final registrationClosed = !program.registrationOpen;
                        return ElevatedButton(
                          onPressed: registrationClosed || enrollmentStatus == EnrollmentStatus.pending
                              ? null
                              : () {
                                  if (enrollmentStatus == EnrollmentStatus.granted) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ProgramLearningScreen(),
                                      ),
                                    );
                                  } else {
                                    _showApplicationModal();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: enrollmentStatus == EnrollmentStatus.pending
                                ? const Color(0xFFFFF9E6)
                                : registrationClosed
                                    ? const Color(0xFFE5E9F0)
                                    : _primaryBlue,
                            foregroundColor: enrollmentStatus == EnrollmentStatus.pending
                                ? const Color(0xFFF59E0B)
                                : registrationClosed
                                    ? _textSecondary
                                    : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: enrollmentStatus == EnrollmentStatus.pending
                                  ? const BorderSide(color: Color(0xFFFCD34D))
                                  : BorderSide.none,
                            ),
                          ),
                          child: enrollmentStatus == EnrollmentStatus.pending
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
                                  registrationClosed
                                      ? 'Registration Closed'
                                      : enrollmentStatus == EnrollmentStatus.granted
                                          ? 'Continue'
                                          : 'Apply Now',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
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

  IconData _learnIconFor(int index) {
    const icons = [
      Icons.psychology,
      Icons.account_tree,
      Icons.palette,
      Icons.touch_app,
      Icons.insights,
      Icons.build,
    ];
    return icons[index % icons.length];
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

  const _LearnRow({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Icon(icon, color: _primaryBlue, size: 24),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
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
