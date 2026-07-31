import 'package:flutter/foundation.dart';
import '../models/certificate.dart';
import 'notification_service.dart';

class CertificateStore extends ChangeNotifier {
  static final CertificateStore _instance = CertificateStore._internal();
  factory CertificateStore() => _instance;
  static CertificateStore get instance => _instance;

  CertificateStore._internal() {
    _initMockCertificates();
  }

  final List<Certificate> _certificates = [];

  List<Certificate> get certificates => List.unmodifiable(_certificates);

  void _initMockCertificates() {
    _certificates.addAll([
      Certificate(
        id: 'CERT-2023-001',
        programId: 'ux-ui-foundations-bootcamp',
        programTitle: 'Foundations of Product Design',
        recipientName: 'Alex',
        recipientEmail: 'alex@nextern.edu',
        issueDate: DateTime(2023, 10, 12),
        issuerName: 'Nextern Academy',
        instructorName: 'Sarah Jenkins',
        skillsMastered: ['Figma', 'User Research', 'Wireframing'],
        verificationCode: 'NX-CERT-90812',
      ),
      Certificate(
        id: 'CERT-2023-002',
        programId: 'agile-methodology',
        programTitle: 'Agile Methodology Sprint',
        recipientName: 'Alex',
        recipientEmail: 'alex@nextern.edu',
        issueDate: DateTime(2023, 8, 5),
        issuerName: 'Nextern Academy',
        instructorName: 'Marcus Reid',
        skillsMastered: ['Scrum', 'Sprint Planning', 'Kanban'],
        verificationCode: 'NX-CERT-87421',
      ),
      Certificate(
        id: 'CERT-2023-003',
        programId: 'frontend-dev-intro',
        programTitle: 'Intro to UI Design',
        recipientName: 'Alex',
        recipientEmail: 'alex@nextern.edu',
        issueDate: DateTime(2023, 1, 22),
        issuerName: 'Nextern Academy',
        instructorName: 'Elena Rostova',
        skillsMastered: ['Design Systems', 'Typography', 'Color Theory'],
        verificationCode: 'NX-CERT-76123',
      ),
    ]);
  }

  /// Returns all certificates issued for a particular student name or email.
  List<Certificate> getCertificatesForUser(String query) {
    if (query.trim().isEmpty) return certificates;
    final q = query.toLowerCase();
    return _certificates.where((cert) {
      return cert.recipientName.toLowerCase().contains(q) ||
          cert.recipientEmail.toLowerCase().contains(q);
    }).toList();
  }

  /// Checks if a certificate has already been issued for a student in a program.
  bool isCertificateIssued(String programTitle, String studentName) {
    final titleMatch = programTitle.trim().toLowerCase();
    final nameMatch = studentName.trim().toLowerCase();
    return _certificates.any((c) =>
        c.programTitle.trim().toLowerCase() == titleMatch &&
        c.recipientName.trim().toLowerCase() == nameMatch);
  }

  /// Returns a certificate issued for a student in a program if it exists.
  Certificate? getCertificateForStudent(String programTitle, String studentName) {
    final titleMatch = programTitle.trim().toLowerCase();
    final nameMatch = studentName.trim().toLowerCase();
    for (final c in _certificates) {
      if (c.programTitle.trim().toLowerCase() == titleMatch &&
          c.recipientName.trim().toLowerCase() == nameMatch) {
        return c;
      }
    }
    return null;
  }

  /// Issues a new certificate and sends a notification to the student.
  Future<void> issueCertificate(Certificate cert) async {
    // Remove duplicate if exists before re-issuing
    _certificates.removeWhere((c) =>
        c.programTitle.trim().toLowerCase() == cert.programTitle.trim().toLowerCase() &&
        c.recipientName.trim().toLowerCase() == cert.recipientName.trim().toLowerCase());

    _certificates.insert(0, cert);
    notifyListeners();

    // Trigger student notification badge
    NotificationService.instance.addLearnerNotification(
      title: 'Certificate Issued: ${cert.programTitle}',
      content: 'Congratulations ${cert.recipientName}! Your official certificate for "${cert.programTitle}" has been issued. You can now view and download it in your Completed tab.',
    );
  }

  /// Deletes a certificate by ID.
  Future<void> deleteCertificate(String id) async {
    _certificates.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
