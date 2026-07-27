import 'package:flutter/foundation.dart';

import '../models/program.dart';
import 'program_service.dart';
import 'saved_program_service.dart';

class ProgramStore extends ChangeNotifier {
  static final ProgramStore _instance = ProgramStore._internal();
  factory ProgramStore() => _instance;
  static ProgramStore get instance => _instance;

  ProgramStore._internal()
      : _programService = ProgramService(),
        _savedService = SavedProgramService();

  /// Constructor for use in tests only — injects fake services.
  @visibleForTesting
  ProgramStore.forTesting({ProgramService? programService, SavedProgramService? savedService})
      : _programService = programService ?? ProgramService(),
        _savedService = savedService ?? SavedProgramService();

  final ProgramService _programService;
  final SavedProgramService _savedService;

  List<Program> _programs = [];
  bool _isLoading = false;
  String? _errorMessage;
  Set<String> _savedProgramIds = {};

  List<Program> get programs => _programs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Set<String> get savedProgramIds => Set.unmodifiable(_savedProgramIds);

  /// Loads programs from JSON and saved IDs from SharedPreferences.
  /// Safe to call multiple times — skips if already loaded and no error.
  Future<void> initialize() async {
    if (_programs.isNotEmpty && _errorMessage == null) return;
    await _load();
  }

  /// Re-attempts a failed [initialize]. Always triggers a fresh load.
  Future<void> retry() async {
    await _load();
  }

  Future<void> _load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _programService.loadPrograms(),
        _savedService.loadSavedProgramIds(),
      ]);
      _programs = results[0] as List<Program>;
      _savedProgramIds = results[1] as Set<String>;
      _errorMessage = null;
    } on ProgramServiceException catch (e) {
      _errorMessage = e.message;
      _programs = [];
    } catch (e) {
      _errorMessage = 'An unexpected error occurred while loading programs.';
      _programs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggles the saved state for [programId] and persists the change.
  Future<void> toggleSaved(String programId) async {
    if (_savedProgramIds.contains(programId)) {
      _savedProgramIds = {..._savedProgramIds}..remove(programId);
    } else {
      _savedProgramIds = {..._savedProgramIds, programId};
    }
    notifyListeners();
    await _savedService.saveProgramIds(_savedProgramIds);
  }

  /// Returns the [Program] with the given [id], or null if not found.
  Program? findById(String id) {
    try {
      return _programs.firstWhere((p) => p.id == id);
    } on StateError {
      return null;
    }
  }
}
