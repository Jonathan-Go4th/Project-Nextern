import 'package:flutter/material.dart';
import 'admin_review_assignment_screen.dart';
import '../services/enrollment_service.dart';
import '../services/certificate_store.dart';
import '../services/submission_store.dart';
import '../widgets/admin_certificate_generator_dialog.dart';
import '../widgets/certificate_viewer_dialog.dart';

const Color _primaryBlue = Color(0xFF3157F6);
const Color _background = Color(0xFFF8FAFD);
const Color _textPrimary = Color(0xFF202532);
const Color _textSecondary = Color(0xFF788394);
const Color _border = Color(0xFFE2E7EF);

class AdminProgramSubmissionsScreen extends StatefulWidget {
  final Map<String, dynamic> program;

  const AdminProgramSubmissionsScreen({super.key, required this.program});

  @override
  State<AdminProgramSubmissionsScreen> createState() => _AdminProgramSubmissionsScreenState();
}

class _AdminProgramSubmissionsScreenState extends State<AdminProgramSubmissionsScreen> {
  bool _showSubmissions = true;
  String _selectedWeek = 'Week 1';
  final List<String> _weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];

  void _showWeekPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Select Module', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ..._weeks.map((week) => ListTile(
                title: Text(week, style: TextStyle(color: week == _selectedWeek ? _primaryBlue : _textPrimary, fontWeight: week == _selectedWeek ? FontWeight.bold : FontWeight.normal)),
                trailing: week == _selectedWeek ? const Icon(Icons.check, color: _primaryBlue) : null,
                onTap: () {
                  setState(() => _selectedWeek = week);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getSubmissions() {
    final progressList = SubmissionStore.instance.getProgressForProgram(widget.program['title']);
    List<Map<String, dynamic>> list = [];

    for (final prog in progressList) {
      final sub = prog.submissions[_selectedWeek];
      list.add({
        'name': prog.studentName,
        'email': prog.studentEmail,
        'submittedAt': sub?.submittedAt ?? '1 day ago',
        'status': sub?.status ?? 'Unsubmitted',
        'assignmentPrompt': sub?.assignmentPrompt ?? 'Please complete the week assignment.',
        'submissionText': sub?.submissionText ?? 'No submission text available.',
        'score': sub?.score ?? 0,
        'feedback': sub?.feedback ?? '',
        'completedWeeksCount': prog.completedWeeksCount,
        'totalWeeks': prog.totalWeeks,
        'isFullyCompleted': prog.isFullyCompleted,
      });
    }
    return list;
  }

  List<Map<String, String>> _getEnrollmentRequests() {
    return EnrollmentService.instance.pendingRequests;
  }

  Widget _buildPillToggle() {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showSubmissions = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _showSubmissions ? _primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Submissions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _showSubmissions ? Colors.white : _textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showSubmissions = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_showSubmissions ? _primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Enrollment Requests',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !_showSubmissions ? Colors.white : _textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.program['title'], style: const TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
            const Text('Program Submissions & Grading', style: TextStyle(color: _textSecondary, fontSize: 13, fontWeight: FontWeight.normal)),
          ],
        ),
        iconTheme: const IconThemeData(color: _textPrimary),
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([SubmissionStore.instance, CertificateStore.instance]),
        builder: (context, _) {
          final submissions = _getSubmissions();

          return Column(
            children: [
              _buildPillToggle(),
              
              if (_showSubmissions) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filter by Module:', style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                      InkWell(
                        onTap: _showWeekPicker,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: _border),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(_selectedWeek, style: const TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_drop_down, color: _primaryBlue),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: _border),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(24.0),
                    itemCount: submissions.length,
                    itemBuilder: (context, index) {
                      final sub = submissions[index];
                      final status = sub['status'] as String;
                      final isPending = status == 'Pending Review';
                      final isGraded = status == 'Graded';
                      final bool isFullyCompleted = sub['isFullyCompleted'] == true;
                      final int completedCount = sub['completedWeeksCount'] as int;
                      final int totalWeeks = sub['totalWeeks'] as int;

                      return Container(
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
                            // Top Student Header
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: _primaryBlue.withValues(alpha: 0.1),
                                  child: Text(
                                    sub['name'].substring(0, 1),
                                    style: const TextStyle(color: _primaryBlue, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sub['name'],
                                        style: const TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time, size: 14, color: _textSecondary),
                                          const SizedBox(width: 4),
                                          Text(
                                            '$_selectedWeek • ${sub['submittedAt']}',
                                            style: const TextStyle(color: _textSecondary, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Status Badge & Overall Progress
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isGraded
                                        ? const Color(0xFFE4F5E9)
                                        : (isPending ? Colors.orange.withValues(alpha: 0.1) : const Color(0xFFF1F4F9)),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: isGraded
                                          ? const Color(0xFF43A047)
                                          : (isPending ? Colors.orange[800] : _textSecondary),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Overall: $completedCount/$totalWeeks Weeks Passed',
                                  style: TextStyle(
                                    color: isFullyCompleted ? const Color(0xFF43A047) : _textSecondary,
                                    fontSize: 11,
                                    fontWeight: isFullyCompleted ? FontWeight.bold : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Bottom Button Row (Matching Enrollment Requests Accept & Decline StadiumBorder Style)
                            Row(
                              children: [
                                // Edit Grade / Review Button (Outlined StadiumBorder)
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      final result = await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => AdminReviewAssignmentScreen(
                                            programTitle: widget.program['title'],
                                            studentName: sub['name'],
                                            moduleName: _selectedWeek,
                                            assignmentPrompt: sub['assignmentPrompt'],
                                            submissionText: sub['submissionText'],
                                            isGraded: isGraded,
                                            currentScore: sub['score'],
                                            currentFeedback: sub['feedback'],
                                          ),
                                        ),
                                      );
                                      if (result == true) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Grade saved successfully.')));
                                        }
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: _primaryBlue,
                                      side: const BorderSide(color: _primaryBlue),
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: Text(
                                      isPending ? 'Review Grade' : (isGraded ? 'Edit Grade' : 'Grade Task'),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Issue Certificate Button (Elevated StadiumBorder)
                                Expanded(
                                  child: Builder(
                                    builder: (context) {
                                      final isCertIssued = CertificateStore.instance.isCertificateIssued(
                                        widget.program['title'] ?? '',
                                        sub['name'],
                                      );

                                      if (isCertIssued) {
                                        return ElevatedButton.icon(
                                          onPressed: () {
                                            final cert = CertificateStore.instance.getCertificateForStudent(
                                              widget.program['title'] ?? '',
                                              sub['name'],
                                            );
                                            if (cert != null) {
                                              showDialog(
                                                context: context,
                                                builder: (context) => CertificateViewerDialog(certificate: cert),
                                              );
                                            }
                                          },
                                          icon: const Icon(Icons.workspace_premium, size: 16),
                                          label: const Text('Cert Issued', style: TextStyle(fontWeight: FontWeight.bold)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFE4F5E9),
                                            foregroundColor: const Color(0xFF43A047),
                                            shape: const StadiumBorder(),
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            elevation: 0,
                                          ),
                                        );
                                      }

                                      if (isFullyCompleted) {
                                        return ElevatedButton.icon(
                                          onPressed: () async {
                                            await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AdminCertificateGeneratorDialog(
                                                programId: widget.program['id'] ?? 'prog_1',
                                                programTitle: widget.program['title'] ?? 'Program',
                                                studentName: sub['name'],
                                                studentEmail: sub['email'],
                                                company: widget.program['company'],
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.workspace_premium, size: 16),
                                          label: const Text('Issue Cert', style: TextStyle(fontWeight: FontWeight.bold)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF43A047),
                                            foregroundColor: Colors.white,
                                            shape: const StadiumBorder(),
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            elevation: 0,
                                          ),
                                        );
                                      }

                                      return ElevatedButton.icon(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Cannot issue certificate. ${sub['name']} has only passed $completedCount out of $totalWeeks weeks.'),
                                              backgroundColor: Colors.orange[800],
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.lock_outline, size: 16),
                                        label: Text('$completedCount/$totalWeeks Wks', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFF1F4F9),
                                          foregroundColor: _textSecondary,
                                          shape: const StadiumBorder(),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          elevation: 0,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ] else ...[
                Expanded(
                  child: ListenableBuilder(
                    listenable: EnrollmentService.instance,
                    builder: (context, child) {
                      final enrollmentRequests = _getEnrollmentRequests();
                      
                      if (enrollmentRequests.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text(
                              'No pending enrollment requests.',
                              style: TextStyle(color: _textSecondary, fontSize: 16),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        itemCount: enrollmentRequests.length,
                        itemBuilder: (context, index) {
                          final req = enrollmentRequests[index];
                          return Container(
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
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.orange.withValues(alpha: 0.1),
                                      child: Text(
                                        req['name']!.substring(0, 1),
                                        style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(req['name']!, style: const TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                                          Text('Requested: ${req['date']}', style: const TextStyle(color: _textSecondary, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _background,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Reason for joining:', style: TextStyle(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(req['reason']!, style: const TextStyle(color: _textPrimary, fontSize: 14)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          EnrollmentService.instance.declineRequest(req['id']!, req['program'] ?? widget.program['title'], req['name']!);
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rejected ${req['name']}.')));
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          side: const BorderSide(color: Colors.red),
                                          shape: const StadiumBorder(),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                        child: const Text('Decline', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          EnrollmentService.instance.acceptRequest(req['id']!, req['program'] ?? widget.program['title'], req['name']!);
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Accepted ${req['name']} into the program!')));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _primaryBlue,
                                          foregroundColor: Colors.white,
                                          shape: const StadiumBorder(),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          elevation: 0,
                                        ),
                                        child: const Text('Accept', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
