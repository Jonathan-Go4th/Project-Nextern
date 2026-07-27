import 'package:flutter/material.dart';

const Color _primaryBlue = Color(0xFF3157F6);
const Color _background = Color(0xFFF8FAFD);
const Color _textPrimary = Color(0xFF202532);
const Color _textSecondary = Color(0xFF788394);
const Color _border = Color(0xFFE2E7EF);

class AdminReviewAssignmentScreen extends StatefulWidget {
  final String studentName;
  final String moduleName;
  final String assignmentPrompt;
  final String submissionText;
  final bool isGraded;

  const AdminReviewAssignmentScreen({
    super.key,
    required this.studentName,
    required this.moduleName,
    required this.assignmentPrompt,
    required this.submissionText,
    required this.isGraded,
  });

  @override
  State<AdminReviewAssignmentScreen> createState() => _AdminReviewAssignmentScreenState();
}

class _AdminReviewAssignmentScreenState extends State<AdminReviewAssignmentScreen> {
  late TextEditingController _feedbackController;
  late TextEditingController _scoreController;

  @override
  void initState() {
    super.initState();
    _feedbackController = TextEditingController(text: widget.isGraded ? 'Great job analyzing the concepts.' : '');
    _scoreController = TextEditingController(text: widget.isGraded ? '95' : '');
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  void _submitGrade() {
    if (_scoreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a score.')));
      return;
    }
    // Return true to indicate grading was successful
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Review Assignment', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: _textPrimary),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Info Header
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: _primaryBlue.withOpacity(0.1),
                  child: Text(
                    widget.studentName.substring(0, 1),
                    style: const TextStyle(color: _primaryBlue, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.studentName, style: const TextStyle(color: _textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${widget.moduleName} Submission', style: const TextStyle(color: _textSecondary, fontSize: 14)),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.isGraded ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.isGraded ? 'Graded' : 'Pending',
                    style: TextStyle(
                      color: widget.isGraded ? Colors.green[800] : Colors.orange[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Assignment Details
            const Text('Assignment Prompt', style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border),
              ),
              child: Text(widget.assignmentPrompt, style: const TextStyle(color: _textSecondary, fontSize: 14, height: 1.5)),
            ),
            const SizedBox(height: 24),

            const Text('Student Submission', style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border),
              ),
              child: Text(widget.submissionText, style: const TextStyle(color: _textPrimary, fontSize: 14, height: 1.6)),
            ),
            const SizedBox(height: 24),

            const Text('Attached Files', style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Assignment_1_Final.pdf', style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                        SizedBox(height: 2),
                        Text('1.2 MB', style: TextStyle(color: _textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.download, color: _primaryBlue),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloading file...')));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Divider(color: _border),
            const SizedBox(height: 24),

            // Grading Section
            const Text('Grade & Feedback', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            
            const Text('Score (out of 100)', style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _scoreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'e.g. 95',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryBlue, width: 2)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Feedback Remarks', style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Type your feedback here...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primaryBlue, width: 2)),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitGrade,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  widget.isGraded ? 'Update Grade' : 'Submit Grade',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
