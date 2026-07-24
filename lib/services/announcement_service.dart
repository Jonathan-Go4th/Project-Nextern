import 'package:flutter/material.dart';

class AnnouncementService extends ChangeNotifier {
  static final AnnouncementService _instance = AnnouncementService._internal();

  factory AnnouncementService() {
    return _instance;
  }

  static AnnouncementService get instance => _instance;

  AnnouncementService._internal();

  Map<String, String> _announcement = {
    'title': 'System Maintenance',
    'body': 'Platform will be down for maintenance this Sunday 2 AM - 4 AM.',
    'date': 'Oct 25',
    'link': '',
    'image': '',
  };

  Map<String, String> get announcement => _announcement;

  void updateAnnouncement({
    required String title,
    required String body,
    String link = '',
    String image = '',
  }) {
    _announcement = {
      'title': title,
      'body': body,
      'date': 'Just now',
      'link': link,
      'image': image,
    };
    notifyListeners();
  }
}
