import 'package:shared_preferences/shared_preferences.dart';

enum SessionRole {
  learner,
  admin,
}

class SessionProfile {
  const SessionProfile({
    required this.role,
    required this.displayName,
    required this.email,
  });

  final SessionRole role;
  final String displayName;
  final String email;
}

class AppSession {
  static const String _roleKey = 'signed_in_role';
  static const String _displayNameKey = 'signed_in_display_name';
  static const String _emailKey = 'signed_in_email';

  const AppSession._();

  static String _encodeRole(SessionRole role) {
    switch (role) {
      case SessionRole.learner:
        return 'learner';
      case SessionRole.admin:
        return 'admin';
    }
  }

  static SessionRole? _decodeRole(String? storedRole) {
    switch (storedRole) {
      case 'learner':
        return SessionRole.learner;
      case 'admin':
        return SessionRole.admin;
      default:
        return null;
    }
  }

  static String _defaultName(SessionRole role) {
    return role == SessionRole.admin ? 'Administrator' : 'Alex';
  }

  static String _nameFromEmail(String email, SessionRole role) {
    final String localPart = email.split('@').first.trim();

    if (localPart.isEmpty) {
      return _defaultName(role);
    }

    final List<String> words = localPart
        .replaceAll(RegExp(r'[._-]+'), ' ')
        .split(RegExp(r'\s+'))
        .where((String word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return _defaultName(role);
    }

    return words
        .map(
          (String word) =>
              '${word.substring(0, 1).toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  static Future<SessionProfile?> getProfile() async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();

    final SessionRole? role =
        _decodeRole(preferences.getString(_roleKey));

    if (role == null) {
      return null;
    }

    final String email =
        (preferences.getString(_emailKey) ?? '').trim();
    final String storedName =
        (preferences.getString(_displayNameKey) ?? '').trim();

    final String displayName = storedName.isNotEmpty
        ? storedName
        : _nameFromEmail(email, role);

    return SessionProfile(
      role: role,
      displayName: displayName,
      email: email,
    );
  }

  static Future<SessionRole?> getRole() async {
    final SessionProfile? profile = await getProfile();
    return profile?.role;
  }

  static Future<void> signInAs(
    SessionRole role, {
    String? displayName,
    String? email,
  }) async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();

    final String cleanedEmail = (email ?? '').trim();
    final String cleanedName = (displayName ?? '').trim();
    final String resolvedName = cleanedName.isNotEmpty
        ? cleanedName
        : _nameFromEmail(cleanedEmail, role);

    await preferences.setString(_roleKey, _encodeRole(role));
    await preferences.setString(_displayNameKey, resolvedName);
    await preferences.setString(_emailKey, cleanedEmail);
  }

  static Future<void> logOut() async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();

    await preferences.remove(_roleKey);
    await preferences.remove(_displayNameKey);
    await preferences.remove(_emailKey);
  }
}
