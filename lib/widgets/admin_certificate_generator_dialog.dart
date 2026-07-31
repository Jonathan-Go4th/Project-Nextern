import 'package:flutter/material.dart';
import '../models/certificate.dart';
import '../services/certificate_store.dart';

const Color _primaryBlue = Color(0xFF3157F6);
const Color _background = Color(0xFFF8FAFD);
const Color _textPrimary = Color(0xFF202532);
const Color _textSecondary = Color(0xFF788394);
const Color _border = Color(0xFFE2E7EF);

class AdminCertificateGeneratorDialog extends StatefulWidget {
  final String programId;
  final String programTitle;
  final String studentName;
  final String? studentEmail;
  final String? company;

  const AdminCertificateGeneratorDialog({
    super.key,
    required this.programId,
    required this.programTitle,
    required this.studentName,
    this.studentEmail,
    this.company,
  });

  @override
  State<AdminCertificateGeneratorDialog> createState() => _AdminCertificateGeneratorDialogState();
}

class _AdminCertificateGeneratorDialogState extends State<AdminCertificateGeneratorDialog> {
  late TextEditingController _studentNameController;
  late TextEditingController _studentEmailController;
  late TextEditingController _instructorController;
  late TextEditingController _issuerController;
  late TextEditingController _skillInputController;

  DateTime _issueDate = DateTime.now();
  final List<String> _skills = ['Figma', 'UI/UX Design', 'Problem Solving', 'Project Management'];

  @override
  void initState() {
    super.initState();
    _studentNameController = TextEditingController(text: widget.studentName);
    _studentEmailController = TextEditingController(text: widget.studentEmail ?? 'student@nextern.edu');
    _instructorController = TextEditingController(text: 'Senior Lead Educator');
    _issuerController = TextEditingController(text: widget.company ?? 'Nextern Academy');
    _skillInputController = TextEditingController();
  }

  @override
  void dispose() {
    _studentNameController.dispose();
    _studentEmailController.dispose();
    _instructorController.dispose();
    _issuerController.dispose();
    _skillInputController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _addSkill() {
    final text = _skillInputController.text.trim();
    if (text.isNotEmpty && !_skills.contains(text)) {
      setState(() {
        _skills.add(text);
        _skillInputController.clear();
      });
    }
  }

  Future<void> _issueCertificate() async {
    if (_studentNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter student name.')),
      );
      return;
    }

    final String certId = 'CERT-2026-${(1000 + DateTime.now().millisecond % 9000)}';
    final String verCode = 'NX-CERT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final cert = Certificate(
      id: certId,
      programId: widget.programId,
      programTitle: widget.programTitle,
      recipientName: _studentNameController.text.trim(),
      recipientEmail: _studentEmailController.text.trim(),
      issueDate: _issueDate,
      issuerName: _issuerController.text.trim().isEmpty ? 'Nextern Academy' : _issuerController.text.trim(),
      instructorName: _instructorController.text.trim().isEmpty ? 'Senior Educator' : _instructorController.text.trim(),
      skillsMastered: _skills,
      verificationCode: verCode,
    );

    await CertificateStore.instance.issueCertificate(cert);

    if (mounted) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Certificate issued for ${_studentNameController.text.trim()}!'),
          backgroundColor: const Color(0xFF43A047),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.workspace_premium, color: Color(0xFF43A047), size: 24),
              ),
              const SizedBox(width: 12),
              const Text('Issue Certificate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _textPrimary)),
            ],
          ),
          const SizedBox(height: 6),
          Text(widget.programTitle, style: const TextStyle(fontSize: 13, color: _primaryBlue, fontWeight: FontWeight.w600)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: _border),
            const SizedBox(height: 12),

            _buildFieldLabel('Learner Name'),
            const SizedBox(height: 6),
            TextField(
              controller: _studentNameController,
              decoration: _inputDecoration('Student Name'),
            ),
            const SizedBox(height: 14),

            _buildFieldLabel('Learner Email'),
            const SizedBox(height: 6),
            TextField(
              controller: _studentEmailController,
              decoration: _inputDecoration('student@nextern.edu'),
            ),
            const SizedBox(height: 14),

            _buildFieldLabel('Instructor Signature / Role'),
            const SizedBox(height: 6),
            TextField(
              controller: _instructorController,
              decoration: _inputDecoration('e.g. Sarah Jenkins (Senior Instructor)'),
            ),
            const SizedBox(height: 14),

            _buildFieldLabel('Issuing Organization'),
            const SizedBox(height: 6),
            TextField(
              controller: _issuerController,
              decoration: _inputDecoration('e.g. Nextern Academy'),
            ),
            const SizedBox(height: 14),

            _buildFieldLabel('Completion Date'),
            const SizedBox(height: 6),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _issueDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() => _issueDate = picked);
                }
              },
              icon: const Icon(Icons.calendar_today, size: 16),
              label: Text(_formatDate(_issueDate)),
              style: OutlinedButton.styleFrom(
                foregroundColor: _textPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 14),

            _buildFieldLabel('Skills Mastered'),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _skillInputController,
                    onSubmitted: (_) => _addSkill(),
                    decoration: _inputDecoration('Add skill tag'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: _primaryBlue),
                  onPressed: _addSkill,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _skills.map((skill) {
                return Chip(
                  label: Text(skill, style: const TextStyle(fontSize: 11)),
                  backgroundColor: const Color(0xFFE8ECFF),
                  deleteIcon: const Icon(Icons.close, size: 14, color: _textSecondary),
                  onDeleted: () {
                    setState(() => _skills.remove(skill));
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: _textSecondary)),
        ),
        ElevatedButton.icon(
          onPressed: _issueCertificate,
          icon: const Icon(Icons.workspace_premium, size: 18),
          label: const Text('Generate & Issue'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF43A047),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _textSecondary));
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _textSecondary, fontSize: 13),
      filled: true,
      fillColor: _background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
    );
  }
}
