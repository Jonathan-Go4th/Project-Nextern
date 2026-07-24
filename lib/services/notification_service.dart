import 'package:flutter/material.dart';
import '../screens/app_session.dart';

class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  static NotificationService get instance => _instance;

  NotificationService._internal();

  bool _isAdmin = false;

  final List<Map<String, String>> _learnerNotifications = [
    {
      'id': '1',
      'title': 'Your assignment is graded',
      'time': '2 hours ago',
      'isRead': 'false',
      'content': 'Great job! You scored 95/100 on the Wireframing Fundamentals assignment. Keep up the good work and proceed to the next module.',
    },
    {
      'id': '2',
      'title': 'New course available: Advanced Prototyping',
      'time': '1 day ago',
      'isRead': 'false',
      'content': 'We just launched the Advanced Prototyping course. Enroll now to learn interactive components and micro-animations in Figma.',
    },
    {
      'id': '3',
      'title': 'Reminder: Midterm UI Prototype due tomorrow',
      'time': '1 day ago',
      'isRead': 'false',
      'content': 'Don\'t forget to submit your Midterm UI Prototype by 11:59 PM tomorrow. Late submissions will incur a penalty.',
    },
  ];

  final List<Map<String, String>> _adminNotifications = [
    {
      'id': '4',
      'title': 'New feedback submitted by Alex',
      'time': '10 mins ago',
      'isRead': 'false',
      'content': 'Alex submitted feedback: "The video lecture for module 2 is buffering heavily." Please check the platform stability.',
    },
    {
      'id': '5',
      'title': 'Submission received for Midterm UI Prototype',
      'time': '1 hour ago',
      'isRead': 'false',
      'content': 'Learner Alex has submitted their Midterm UI Prototype for grading. It is now pending review.',
    },
    {
      'id': '6',
      'title': 'New enrollment request from Alex',
      'time': '5 hours ago',
      'isRead': 'false',
      'content': 'Alex has applied to join "Advanced UX Writing". Approve or reject this request in the Program Manager.',
    },
  ];

  Future<void> loadRole() async {
    final SessionProfile? profile = await AppSession.getProfile();
    _isAdmin = profile?.role == SessionRole.admin;
    notifyListeners();
  }

  List<Map<String, String>> get _activeNotifications => _isAdmin ? _adminNotifications : _learnerNotifications;

  List<Map<String, String>> get notifications => _activeNotifications;

  int get unreadCount => _activeNotifications.where((n) => n['isRead'] == 'false').length;

  void markAsRead(String id) {
    final index = _activeNotifications.indexWhere((n) => n['id'] == id);
    if (index != -1 && _activeNotifications[index]['isRead'] == 'false') {
      _activeNotifications[index]['isRead'] = 'true';
      notifyListeners();
    }
  }

  void delete(String id) {
    _activeNotifications.removeWhere((n) => n['id'] == id);
    notifyListeners();
  }

  void addNotification({required String title, required String content}) {
    _activeNotifications.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'time': 'Just now',
      'isRead': 'false',
      'content': content,
    });
    notifyListeners();
  }

  void addAdminNotification({required String title, required String content}) {
    _adminNotifications.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'time': 'Just now',
      'isRead': 'false',
      'content': content,
    });
    notifyListeners();
  }

  void addLearnerNotification({required String title, required String content}) {
    _learnerNotifications.insert(0, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'time': 'Just now',
      'isRead': 'false',
      'content': content,
    });
    notifyListeners();
  }
}
