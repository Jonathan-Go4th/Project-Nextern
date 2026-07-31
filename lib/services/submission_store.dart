import 'package:flutter/foundation.dart';

class WeeklySubmission {
  final String week;
  final String assignmentPrompt;
  final String submissionText;
  final String submittedAt;
  String status; // 'Graded', 'Pending Review', 'Unsubmitted'
  int score;
  String feedback;

  WeeklySubmission({
    required this.week,
    required this.assignmentPrompt,
    required this.submissionText,
    required this.submittedAt,
    required this.status,
    this.score = 0,
    this.feedback = '',
  });
}

class StudentProgramProgress {
  final String studentName;
  final String studentEmail;
  final String programTitle;
  final List<String> weeks;
  final Map<String, WeeklySubmission> submissions;

  StudentProgramProgress({
    required this.studentName,
    required this.studentEmail,
    required this.programTitle,
    required this.weeks,
    required this.submissions,
  });

  int get completedWeeksCount {
    int count = 0;
    for (final week in weeks) {
      final sub = submissions[week];
      if (sub != null && sub.status == 'Graded') {
        count++;
      }
    }
    return count;
  }

  int get totalWeeks => weeks.length;

  bool get isFullyCompleted => completedWeeksCount == totalWeeks;
}

class SubmissionStore extends ChangeNotifier {
  static final SubmissionStore _instance = SubmissionStore._internal();
  factory SubmissionStore() => _instance;
  static SubmissionStore get instance => _instance;

  SubmissionStore._internal() {
    _initMockSubmissions();
  }

  final Map<String, List<StudentProgramProgress>> _programProgress = {};

  void _initMockSubmissions() {
    const defaultWeeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];

    _programProgress['Foundations of Product Design'] = [
      StudentProgramProgress(
        studentName: 'Alex',
        studentEmail: 'alex@nextern.edu',
        programTitle: 'Foundations of Product Design',
        weeks: defaultWeeks,
        submissions: {
          'Week 1': WeeklySubmission(week: 'Week 1', assignmentPrompt: 'Explain core concepts of Week 1', submissionText: 'Here is my analysis of product design fundamentals.', submittedAt: '2 days ago', status: 'Graded', score: 95, feedback: 'Excellent work!'),
          'Week 2': WeeklySubmission(week: 'Week 2', assignmentPrompt: 'Wireframing exercise', submissionText: 'Attached wireframes for e-commerce checkout flow.', submittedAt: '1 day ago', status: 'Graded', score: 92, feedback: 'Great layout hierarchy.'),
          'Week 3': WeeklySubmission(week: 'Week 3', assignmentPrompt: 'Interactive prototype in Figma', submissionText: 'Interactive Figma prototype submission.', submittedAt: '12 hours ago', status: 'Graded', score: 98, feedback: 'Outstanding interactions.'),
          'Week 4': WeeklySubmission(week: 'Week 4', assignmentPrompt: 'Final capstone design presentation', submissionText: 'Final capstone presentation slides and video explanation.', submittedAt: '2 hours ago', status: 'Graded', score: 96, feedback: 'Passed capstone!'),
        },
      ),
      StudentProgramProgress(
        studentName: 'Jordan Lee',
        studentEmail: 'jordan@nextern.edu',
        programTitle: 'Foundations of Product Design',
        weeks: defaultWeeks,
        submissions: {
          'Week 1': WeeklySubmission(week: 'Week 1', assignmentPrompt: 'Explain core concepts of Week 1', submissionText: 'Overview of design thinking phases.', submittedAt: '3 days ago', status: 'Graded', score: 88, feedback: 'Good overview.'),
          'Week 2': WeeklySubmission(week: 'Week 2', assignmentPrompt: 'Wireframing exercise', submissionText: 'Low-fi mockups for mobile app.', submittedAt: '2 days ago', status: 'Graded', score: 90, feedback: 'Well structured.'),
          'Week 3': WeeklySubmission(week: 'Week 3', assignmentPrompt: 'Interactive prototype in Figma', submissionText: 'Figma component library and prototypes.', submittedAt: '4 hours ago', status: 'Pending Review', score: 0, feedback: ''),
          'Week 4': WeeklySubmission(week: 'Week 4', assignmentPrompt: 'Final capstone design presentation', submissionText: 'Final capstone project draft.', submittedAt: '1 hour ago', status: 'Pending Review', score: 0, feedback: ''),
        },
      ),
      StudentProgramProgress(
        studentName: 'Taylor Morgan',
        studentEmail: 'taylor@nextern.edu',
        programTitle: 'Foundations of Product Design',
        weeks: defaultWeeks,
        submissions: {
          'Week 1': WeeklySubmission(week: 'Week 1', assignmentPrompt: 'Explain core concepts of Week 1', submissionText: 'Introductory design reflection.', submittedAt: '4 days ago', status: 'Graded', score: 85, feedback: 'Solid start.'),
          'Week 2': WeeklySubmission(week: 'Week 2', assignmentPrompt: 'Wireframing exercise', submissionText: 'Draft wireframes.', submittedAt: '1 day ago', status: 'Pending Review', score: 0, feedback: ''),
          'Week 3': WeeklySubmission(week: 'Week 3', assignmentPrompt: 'Interactive prototype in Figma', submissionText: '', submittedAt: '-', status: 'Unsubmitted', score: 0, feedback: ''),
          'Week 4': WeeklySubmission(week: 'Week 4', assignmentPrompt: 'Final capstone design presentation', submissionText: '', submittedAt: '-', status: 'Unsubmitted', score: 0, feedback: ''),
        },
      ),
      StudentProgramProgress(
        studentName: 'Sam Rivera',
        studentEmail: 'sam@nextern.edu',
        programTitle: 'Foundations of Product Design',
        weeks: defaultWeeks,
        submissions: {
          'Week 1': WeeklySubmission(week: 'Week 1', assignmentPrompt: 'Explain core concepts of Week 1', submissionText: 'Design principles summary.', submittedAt: '5 days ago', status: 'Graded', score: 90, feedback: 'Very clean.'),
          'Week 2': WeeklySubmission(week: 'Week 2', assignmentPrompt: 'Wireframing exercise', submissionText: 'Grid system wireframes.', submittedAt: '3 days ago', status: 'Graded', score: 94, feedback: 'Nice alignment.'),
          'Week 3': WeeklySubmission(week: 'Week 3', assignmentPrompt: 'Interactive prototype in Figma', submissionText: 'Interactive component state variants.', submittedAt: '2 days ago', status: 'Graded', score: 96, feedback: 'Top tier.'),
          'Week 4': WeeklySubmission(week: 'Week 4', assignmentPrompt: 'Final capstone design presentation', submissionText: 'Final capstone presentation video.', submittedAt: '1 day ago', status: 'Graded', score: 95, feedback: 'Passed program!'),
        },
      ),
    ];
  }

  /// Gets progress list for a program. If not initialized, generates default progress list.
  List<StudentProgramProgress> getProgressForProgram(String programTitle) {
    if (!_programProgress.containsKey(programTitle)) {
      const defaultWeeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
      _programProgress[programTitle] = [
        StudentProgramProgress(
          studentName: 'Student 1 (Alex)',
          studentEmail: 'alex@nextern.edu',
          programTitle: programTitle,
          weeks: defaultWeeks,
          submissions: {
            'Week 1': WeeklySubmission(week: 'Week 1', assignmentPrompt: 'Core module assignment', submissionText: 'Sample submission text for Week 1', submittedAt: '2 hours ago', status: 'Graded', score: 95),
            'Week 2': WeeklySubmission(week: 'Week 2', assignmentPrompt: 'Core module assignment', submissionText: 'Sample submission text for Week 2', submittedAt: '1 hour ago', status: 'Graded', score: 92),
            'Week 3': WeeklySubmission(week: 'Week 3', assignmentPrompt: 'Core module assignment', submissionText: 'Sample submission text for Week 3', submittedAt: '30 mins ago', status: 'Graded', score: 90),
            'Week 4': WeeklySubmission(week: 'Week 4', assignmentPrompt: 'Core module assignment', submissionText: 'Sample submission text for Week 4', submittedAt: '10 mins ago', status: 'Graded', score: 96),
          },
        ),
        StudentProgramProgress(
          studentName: 'Student 2 (Jordan)',
          studentEmail: 'jordan@nextern.edu',
          programTitle: programTitle,
          weeks: defaultWeeks,
          submissions: {
            'Week 1': WeeklySubmission(week: 'Week 1', assignmentPrompt: 'Core module assignment', submissionText: 'Sample submission text for Week 1', submittedAt: '3 hours ago', status: 'Graded', score: 88),
            'Week 2': WeeklySubmission(week: 'Week 2', assignmentPrompt: 'Core module assignment', submissionText: 'Sample submission text for Week 2', submittedAt: '2 hours ago', status: 'Graded', score: 90),
            'Week 3': WeeklySubmission(week: 'Week 3', assignmentPrompt: 'Core module assignment', submissionText: 'Sample submission text for Week 3', submittedAt: '1 hour ago', status: 'Pending Review', score: 0),
            'Week 4': WeeklySubmission(week: 'Week 4', assignmentPrompt: 'Core module assignment', submissionText: 'Sample submission text for Week 4', submittedAt: '15 mins ago', status: 'Unsubmitted', score: 0),
          },
        ),
      ];
    }
    return _programProgress[programTitle]!;
  }

  /// Updates a student submission grade for a specific week and notifies listeners.
  void updateSubmissionGrade({
    required String programTitle,
    required String studentName,
    required String week,
    required int score,
    required String feedback,
  }) {
    final list = getProgressForProgram(programTitle);
    final studentProgress = list.firstWhere(
      (p) => p.studentName == studentName,
      orElse: () => list.first,
    );

    final sub = studentProgress.submissions[week];
    if (sub != null) {
      sub.status = 'Graded';
      sub.score = score;
      sub.feedback = feedback;
      notifyListeners();
    }
  }
}
