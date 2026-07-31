class Certificate {
  final String id;
  final String programId;
  final String programTitle;
  final String recipientName;
  final String recipientEmail;
  final DateTime issueDate;
  final String issuerName;
  final String instructorName;
  final List<String> skillsMastered;
  final String verificationCode;

  const Certificate({
    required this.id,
    required this.programId,
    required this.programTitle,
    required this.recipientName,
    required this.recipientEmail,
    required this.issueDate,
    required this.issuerName,
    required this.instructorName,
    this.skillsMastered = const [],
    required this.verificationCode,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'] as String,
      programId: json['programId'] as String? ?? 'program_1',
      programTitle: json['programTitle'] as String,
      recipientName: json['recipientName'] as String,
      recipientEmail: json['recipientEmail'] as String? ?? 'student@nextern.edu',
      issueDate: json['issueDate'] != null
          ? DateTime.parse(json['issueDate'] as String)
          : DateTime.now(),
      issuerName: json['issuerName'] as String? ?? 'Nextern Academy',
      instructorName: json['instructorName'] as String? ?? 'Senior Lead Educator',
      skillsMastered: (json['skillsMastered'] as List<dynamic>?)?.cast<String>() ?? [],
      verificationCode: json['verificationCode'] as String? ?? 'NX-CERT-${json['id']}',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'programId': programId,
        'programTitle': programTitle,
        'recipientName': recipientName,
        'recipientEmail': recipientEmail,
        'issueDate': issueDate.toIso8601String(),
        'issuerName': issuerName,
        'instructorName': instructorName,
        'skillsMastered': skillsMastered,
        'verificationCode': verificationCode,
      };
}
