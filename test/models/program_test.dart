import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../lib/models/program.dart';

Map<String, dynamic> _full() => {
      'id': 'p1',
      'title': 'Flutter Basics',
      'category': 'Mobile',
      'arrangement': 'Online',
      'company': 'Nextern',
      'shortDescription': 'Short',
      'fullDescription': 'Full',
      'tags': ['dart', 'flutter'],
      'imageUrl': 'https://example.com/img.png',
      'duration': '4 weeks',
      'effort': '5 hrs/week',
      'level': 'Beginner',
      'format': 'Video',
      'instructorName': 'Jane Doe',
      'instructorRole': 'Lead Instructor',
      'learningOutcomes': ['Build apps', 'Understand widgets'],
      'registrationOpen': false,
      'isActive': false,
      'sortOrder': 3,
    };

void main() {
  group('Program.fromJson', () {
    test('parses all fields correctly', () {
      final p = Program.fromJson(_full());
      expect(p.id, 'p1');
      expect(p.title, 'Flutter Basics');
      expect(p.category, 'Mobile');
      expect(p.arrangement, 'Online');
      expect(p.company, 'Nextern');
      expect(p.shortDescription, 'Short');
      expect(p.fullDescription, 'Full');
      expect(p.tags, ['dart', 'flutter']);
      expect(p.imageUrl, 'https://example.com/img.png');
      expect(p.duration, '4 weeks');
      expect(p.effort, '5 hrs/week');
      expect(p.level, 'Beginner');
      expect(p.format, 'Video');
      expect(p.instructorName, 'Jane Doe');
      expect(p.instructorRole, 'Lead Instructor');
      expect(p.learningOutcomes, ['Build apps', 'Understand widgets']);
      expect(p.registrationOpen, false);
      expect(p.isActive, false);
      expect(p.sortOrder, 3);
    });

    test('optional fields degrade gracefully when absent', () {
      final p = Program.fromJson({
        'id': 'p2',
        'title': 'Minimal',
        'category': 'Tech',
        'arrangement': 'Remote',
        'company': 'Acme',
      });
      expect(p.imageUrl, isNull);
      expect(p.duration, isNull);
      expect(p.effort, isNull);
      expect(p.level, isNull);
      expect(p.format, isNull);
      expect(p.instructorName, isNull);
      expect(p.instructorRole, isNull);
      expect(p.learningOutcomes, isEmpty);
      expect(p.registrationOpen, true);
      expect(p.isActive, true);
      expect(p.sortOrder, 0);
    });

    test('throws FormatException for missing/empty id', () {
      expect(
        () => Program.fromJson({'title': 'T', 'category': 'C', 'arrangement': 'A', 'company': 'Co'}),
        throwsFormatException,
      );
      expect(
        () => Program.fromJson({'id': '', 'title': 'T', 'category': 'C', 'arrangement': 'A', 'company': 'Co'}),
        throwsFormatException,
      );
    });

    test('throws FormatException for missing/empty title', () {
      expect(
        () => Program.fromJson({'id': 'x', 'category': 'C', 'arrangement': 'A', 'company': 'Co'}),
        throwsFormatException,
      );
      expect(
        () => Program.fromJson({'id': 'x', 'title': '', 'category': 'C', 'arrangement': 'A', 'company': 'Co'}),
        throwsFormatException,
      );
    });

    test('throws FormatException for missing/empty category', () {
      expect(
        () => Program.fromJson({'id': 'x', 'title': 'T', 'arrangement': 'A', 'company': 'Co'}),
        throwsFormatException,
      );
      expect(
        () => Program.fromJson({'id': 'x', 'title': 'T', 'category': '', 'arrangement': 'A', 'company': 'Co'}),
        throwsFormatException,
      );
    });

    test('throws FormatException for missing/empty arrangement', () {
      expect(
        () => Program.fromJson({'id': 'x', 'title': 'T', 'category': 'C', 'company': 'Co'}),
        throwsFormatException,
      );
      expect(
        () => Program.fromJson({'id': 'x', 'title': 'T', 'category': 'C', 'arrangement': '', 'company': 'Co'}),
        throwsFormatException,
      );
    });

    test('throws FormatException for missing/empty company', () {
      expect(
        () => Program.fromJson({'id': 'x', 'title': 'T', 'category': 'C', 'arrangement': 'A'}),
        throwsFormatException,
      );
      expect(
        () => Program.fromJson({'id': 'x', 'title': 'T', 'category': 'C', 'arrangement': 'A', 'company': ''}),
        throwsFormatException,
      );
    });
  });

  group('Program.copyWith', () {
    late Program base;
    setUp(() => base = Program.fromJson(_full()));

    test('overrides individual fields', () {
      final copy = base.copyWith(title: 'New Title', sortOrder: 99);
      expect(copy.title, 'New Title');
      expect(copy.sortOrder, 99);
      expect(copy.id, base.id);
    });

    test('explicitly sets nullable field to null via sentinel', () {
      expect(base.imageUrl, isNotNull);
      final copy = base.copyWith(imageUrl: null);
      expect(copy.imageUrl, isNull);
    });

    test('not passing a nullable field preserves original value', () {
      final copy = base.copyWith(title: 'Changed');
      expect(copy.imageUrl, base.imageUrl);
    });
  });

  group('Program toJson round-trip', () {
    test('fromJson(toJson(x)) produces equivalent Program', () {
      final original = Program.fromJson(_full());
      final roundTripped = Program.fromJson(
        jsonDecode(jsonEncode(original.toJson())) as Map<String, dynamic>,
      );
      expect(roundTripped.id, original.id);
      expect(roundTripped.title, original.title);
      expect(roundTripped.category, original.category);
      expect(roundTripped.arrangement, original.arrangement);
      expect(roundTripped.company, original.company);
      expect(roundTripped.shortDescription, original.shortDescription);
      expect(roundTripped.fullDescription, original.fullDescription);
      expect(roundTripped.tags, original.tags);
      expect(roundTripped.imageUrl, original.imageUrl);
      expect(roundTripped.duration, original.duration);
      expect(roundTripped.effort, original.effort);
      expect(roundTripped.level, original.level);
      expect(roundTripped.format, original.format);
      expect(roundTripped.instructorName, original.instructorName);
      expect(roundTripped.instructorRole, original.instructorRole);
      expect(roundTripped.learningOutcomes, original.learningOutcomes);
      expect(roundTripped.registrationOpen, original.registrationOpen);
      expect(roundTripped.isActive, original.isActive);
      expect(roundTripped.sortOrder, original.sortOrder);
    });
  });
}
