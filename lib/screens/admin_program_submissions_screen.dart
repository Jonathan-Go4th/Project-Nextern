import 'package:flutter/material.dart';
import 'admin_review_assignment_screen.dart';
import '../services/enrollment_service.dart';

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
    int count = _selectedWeek == 'Week 1' ? 5 : (_selectedWeek == 'Week 2' ? 3 : 1);
    List<Map<String, dynamic>> submissions = [];
    for (int i = 0; i < count; i++) {
      bool isPending = i < 2; 
      submissions.add({
        'name': 'Student ${i + 1}',
        'submittedAt': '${(i + 1) * 2} hours ago',
        'status': isPending ? 'Pending Review' : 'Graded',
        'assignmentPrompt': 'Please explain the core concepts learned in ${_selectedWeek}.',
        'submissionText': 'I believe the core concepts of ${_selectedWeek} revolve around understanding the foundational elements discussed in the module. My approach was to...'
      });
    }
    return submissions;
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
    final submissions = _getSubmissions();
    final requests = _getEnrollmentRequests();

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.program['title'], style: const TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
            const Text('Program Management', style: TextStyle(color: _textSecondary, fontSize: 13, fontWeight: FontWeight.normal)),
          ],
        ),
        iconTheme: const IconThemeData(color: _textPrimary),
        elevation: 0,
      ),
      body: Column(
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
                  final isPending = sub['status'] == 'Pending Review';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _border),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: _primaryBlue.withOpacity(0.1),
                          child: Text(
                            sub['name'].substring(0, 1),
                            style: const TextStyle(color: _primaryBlue, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sub['name'],
                                style: const TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 14, color: _textSecondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    sub['submittedAt'],
                                    style: const TextStyle(color: _textSecondary, fontSize: 13),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isPending ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  sub['status'],
                                  style: TextStyle(
                                    color: isPending ? Colors.orange[800] : Colors.green[800],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AdminReviewAssignmentScreen(
                                  studentName: sub['name'],
                                  moduleName: _selectedWeek,
                                  assignmentPrompt: sub['assignmentPrompt'],
                                  submissionText: sub['submissionText'],
                                  isGraded: !isPending,
                                ),
                              ),
                            );
                            if (result == true) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Grade submitted successfully.')));
                              setState(() {});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPending ? _primaryBlue : _background,
                            foregroundColor: isPending ? Colors.white : _primaryBlue,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: isPending ? Colors.transparent : _primaryBlue),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          child: Text(isPending ? 'Review' : 'View Grade', style: const TextStyle(fontWeight: FontWeight.bold)),
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
                              backgroundColor: Colors.orange.withOpacity(0.1),
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
      ]
    ],
      ),
    );
  }
}
