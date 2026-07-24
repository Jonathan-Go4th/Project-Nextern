import 'package:flutter/material.dart';
import 'notification_service.dart';

enum EnrollmentStatus { notApplied, pending, granted, rejected }

class EnrollmentService extends ChangeNotifier {
  static final EnrollmentService _instance = EnrollmentService._internal();

  factory EnrollmentService() {
    return _instance;
  }

  static EnrollmentService get instance => _instance;

  EnrollmentService._internal();

  final Map<String, EnrollmentStatus> _programStatus = {};
  
  final List<Map<String, String>> _pendingRequests = [
    {'id': 'req_1', 'program': 'UI/UX Design Masterclass', 'name': 'Michael Scott', 'date': 'Today, 9:00 AM', 'reason': 'I want to upskill my team management.'},
    {'id': 'req_2', 'program': 'Advanced Figma Prototyping', 'name': 'Dwight Schrute', 'date': 'Yesterday, 2:30 PM', 'reason': 'Assistant to the Regional Manager.'},
    {'id': 'req_3', 'program': 'User Research Fundamentals', 'name': 'Jim Halpert', 'date': 'Oct 12, 10:15 AM', 'reason': 'Looking to learn new skills.'},
  ];

  List<Map<String, String>> get pendingRequests => _pendingRequests;

  EnrollmentStatus getStatus(String programTitle) {
    return _programStatus[programTitle] ?? EnrollmentStatus.notApplied;
  }

  void submitApplication({required String programTitle, required String reason}) {
    _programStatus[programTitle] = EnrollmentStatus.pending;
    _pendingRequests.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'program': programTitle,
      'name': 'Current Learner', 
      'date': 'Just now',
      'reason': reason,
    });
    
    NotificationService.instance.addAdminNotification(
      title: 'New enrollment request from Current Learner',
      content: 'Current Learner has applied to join "$programTitle". Approve or reject this request in the Program Manager.',
    );
    notifyListeners();
  }

  void acceptRequest(String id, String programTitle, String learnerName) {
    _pendingRequests.removeWhere((req) => req['id'] == id);
    if (learnerName == 'Current Learner') {
      _programStatus[programTitle] = EnrollmentStatus.granted;
      NotificationService.instance.addLearnerNotification(
        title: 'Enrollment Approved',
        content: 'Your enrollment for "$programTitle" has been granted! You can now start learning.',
      );
    }
    notifyListeners();
  }

  void declineRequest(String id, String programTitle, String learnerName) {
    _pendingRequests.removeWhere((req) => req['id'] == id);
    if (learnerName == 'Current Learner') {
      _programStatus[programTitle] = EnrollmentStatus.rejected;
      NotificationService.instance.addLearnerNotification(
        title: 'Enrollment Rejected',
        content: 'Unfortunately, your application for "$programTitle" was not approved at this time.',
      );
    }
    notifyListeners();
  }
}
