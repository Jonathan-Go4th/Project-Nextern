import 'package:flutter_test/flutter_test.dart';

import 'package:Nextern/models/program.dart';
import 'package:Nextern/services/program_service.dart';
import 'package:Nextern/services/program_store.dart';
import 'package:Nextern/services/saved_program_service.dart';


// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

Program _makeProgram(String id) => Program(
      id: id,
      title: 'Program $id',
      category: 'Cat',
      arrangement: 'Online',
      company: 'Co',
      shortDescription: '',
      fullDescription: '',
      tags: const [],
    );

class _FakeProgramService extends ProgramService {
  final List<Program> _programs;
  final bool shouldThrow;

  _FakeProgramService(this._programs, {this.shouldThrow = false});

  @override
  Future<List<Program>> loadPrograms() async {
    if (shouldThrow) throw const ProgramServiceException('load failed');
    return _programs;
  }
}

class _FakeSavedService extends SavedProgramService {
  Set<String> _ids;
  _FakeSavedService([Set<String>? initial]) : _ids = initial ?? {};

  @override
  Future<Set<String>> loadSavedProgramIds() async => Set.of(_ids);

  @override
  Future<void> saveProgramIds(Set<String> ids) async => _ids = Set.of(ids);
}

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

ProgramStore _store({
  List<Program>? programs,
  Set<String>? savedIds,
  bool throwOnLoad = false,
}) =>
    ProgramStore.forTesting(
      programService: _FakeProgramService(
        programs ?? [_makeProgram('p1'), _makeProgram('p2')],
        shouldThrow: throwOnLoad,
      ),
      savedService: _FakeSavedService(savedIds),
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('ProgramStore.initialize()', () {
    test('success: loads programs and savedIds, isLoading false→true→false, errorMessage null', () async {
      final store = _store(savedIds: {'p1'});

      final states = <bool>[];
      store.addListener(() => states.add(store.isLoading));

      await store.initialize();

      expect(store.programs.length, 2);
      expect(store.savedProgramIds, {'p1'});
      expect(store.errorMessage, isNull);
      expect(store.isLoading, false);
      expect(states, [true, false]);
    });

    test('skips reload when already loaded without error', () async {
      final store = _store();
      await store.initialize();

      int callCount = 0;
      store.addListener(() => callCount++);

      await store.initialize();
      expect(callCount, 0);
    });

    test('failure: errorMessage set, isLoading resolves to false', () async {
      final store = _store(throwOnLoad: true);
      await store.initialize();

      expect(store.errorMessage, isNotNull);
      expect(store.programs, isEmpty);
      expect(store.isLoading, false);
    });
  });

  group('ProgramStore.retry()', () {
    test('re-attempts load even after a previous success', () async {
      final store = _store();
      await store.initialize();

      int callCount = 0;
      store.addListener(() => callCount++);

      await store.retry();
      expect(callCount, greaterThan(0));
      expect(store.programs.length, 2);
    });
  });

  group('ProgramStore.toggleSaved()', () {
    test('adds id when not saved, then removes it, notifying listeners each time', () async {
      final store = _store();
      await store.initialize();

      int notifications = 0;
      store.addListener(() => notifications++);

      await store.toggleSaved('p1');
      expect(store.savedProgramIds.contains('p1'), true);
      expect(notifications, 1);

      await store.toggleSaved('p1');
      expect(store.savedProgramIds.contains('p1'), false);
      expect(notifications, 2);
    });
  });

  group('ProgramStore.findById()', () {
    test('returns correct Program for known id', () async {
      final store = _store();
      await store.initialize();

      final p = store.findById('p2');
      expect(p, isNotNull);
      expect(p!.id, 'p2');
    });

    test('returns null for unknown id', () async {
      final store = _store();
      await store.initialize();

      expect(store.findById('unknown'), isNull);
    });
  });
}
