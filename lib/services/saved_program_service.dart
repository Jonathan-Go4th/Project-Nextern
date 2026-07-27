import 'package:shared_preferences/shared_preferences.dart';

class SavedProgramService {
  static const String _prefsKey = 'saved_program_ids';

  Future<Set<String>> loadSavedProgramIds() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> stored = prefs.getStringList(_prefsKey) ?? [];
    return stored.toSet();
  }

  Future<void> saveProgramIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, ids.toList());
  }
}
