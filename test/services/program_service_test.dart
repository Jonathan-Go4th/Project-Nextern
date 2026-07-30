import 'package:flutter_test/flutter_test.dart';

import 'package:Nextern/services/program_service.dart';


const _validJson = '''
[
  {"id":"a","title":"Alpha","category":"Tech","arrangement":"Online","company":"Acme","sortOrder":2,"isActive":true},
  {"id":"b","title":"Beta","category":"Tech","arrangement":"Online","company":"Acme","sortOrder":1,"isActive":true},
  {"id":"c","title":"Gamma","category":"Tech","arrangement":"Online","company":"Acme","sortOrder":3,"isActive":false}
]
''';

void main() {
  late ProgramService svc;
  setUp(() => svc = ProgramService());

  test('loads and parses valid JSON', () async {
    final programs = await svc.parsePrograms(_validJson);
    expect(programs.length, 2);
  });

  test('filters out programs where isActive is false', () async {
    final programs = await svc.parsePrograms(_validJson);
    expect(programs.every((p) => p.isActive), true);
    expect(programs.any((p) => p.id == 'c'), false);
  });

  test('sorts programs by sortOrder ascending', () async {
    final programs = await svc.parsePrograms(_validJson);
    expect(programs[0].id, 'b'); // sortOrder 1
    expect(programs[1].id, 'a'); // sortOrder 2
  });

  test('throws ProgramServiceException for malformed JSON', () async {
    await expectLater(
      svc.parsePrograms('not json {{{'),
      throwsA(isA<ProgramServiceException>()),
    );
  });

  test('throws ProgramServiceException when root is not a list', () async {
    await expectLater(
      svc.parsePrograms('{"id":"x"}'),
      throwsA(isA<ProgramServiceException>()),
    );
  });

  test('throws ProgramServiceException with per-entry index on bad entry', () async {
    const bad = '''
[
  {"id":"ok","title":"OK","category":"C","arrangement":"A","company":"Co"},
  {"id":"","title":"Bad","category":"C","arrangement":"A","company":"Co"}
]
''';
    await expectLater(
      svc.parsePrograms(bad),
      throwsA(
        isA<ProgramServiceException>().having(
          (e) => e.message,
          'message',
          contains('index 1'),
        ),
      ),
    );
  });
}
