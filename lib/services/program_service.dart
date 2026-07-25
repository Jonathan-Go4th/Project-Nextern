import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/program.dart';

class ProgramServiceException implements Exception {
  final String message;
  const ProgramServiceException(this.message);

  @override
  String toString() => 'ProgramServiceException: $message';
}

class ProgramService {
  static const String _assetPath = 'assets/data/programs.json';

  /// Loads [_assetPath], decodes it, and returns only active programs
  /// sorted ascending by [Program.sortOrder].
  ///
  /// Throws [ProgramServiceException] if the asset is missing, the JSON is
  /// not a list, or any individual entry fails [Program.fromJson] validation.
  Future<List<Program>> loadPrograms() async {
    final String raw;
    try {
      raw = await rootBundle.loadString(_assetPath);
    } catch (_) {
      throw const ProgramServiceException(
        'Could not load programs data. '
        'Ensure assets/data/programs.json exists and is declared in pubspec.yaml.',
      );
    }
    return parsePrograms(raw);
  }

  /// Parses a raw JSON string and returns only active programs sorted by
  /// [Program.sortOrder] ascending. Exposed for testing without [rootBundle].
  Future<List<Program>> parsePrograms(String raw) async {
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (_) {
      throw const ProgramServiceException(
        'programs.json contains invalid JSON and could not be parsed.',
      );
    }

    if (decoded is! List) {
      throw const ProgramServiceException(
        'programs.json must contain a JSON array at the top level.',
      );
    }

    final List<Program> programs = [];
    for (int i = 0; i < decoded.length; i++) {
      final entry = decoded[i];
      if (entry is! Map<String, dynamic>) {
        throw ProgramServiceException(
          'programs.json entry at index $i is not a JSON object.',
        );
      }
      try {
        programs.add(Program.fromJson(entry));
      } on FormatException catch (e) {
        throw ProgramServiceException(
          'programs.json entry at index $i failed validation: ${e.message}',
        );
      }
    }

    return programs.where((p) => p.isActive).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }
}
