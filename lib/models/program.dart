class Program {
  final String id;
  final String title;
  final String category;
  final String arrangement;
  final String company;
  final String shortDescription;
  final String fullDescription;
  final List<String> tags;
  final String? imageUrl;
  final String? duration;
  final String? effort;
  final String? level;
  final String? format;
  final String? instructorName;
  final String? instructorRole;
  final List<String> learningOutcomes;
  final bool registrationOpen;
  final bool isActive;
  final int sortOrder;

  const Program({
    required this.id,
    required this.title,
    required this.category,
    required this.arrangement,
    required this.company,
    required this.shortDescription,
    required this.fullDescription,
    required this.tags,
    this.imageUrl,
    this.duration,
    this.effort,
    this.level,
    this.format,
    this.instructorName,
    this.instructorRole,
    this.learningOutcomes = const [],
    this.registrationOpen = true,
    this.isActive = true,
    this.sortOrder = 0,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    if (json['id'] is! String || (json['id'] as String).isEmpty) {
      throw FormatException('Program is missing a valid "id" field: $json');
    }
    if (json['title'] is! String || (json['title'] as String).isEmpty) {
      throw FormatException(
        'Program "${json['id']}" is missing a valid "title" field.',
      );
    }
    if (json['category'] is! String || (json['category'] as String).isEmpty) {
      throw FormatException(
        'Program "${json['id']}" is missing a valid "category" field.',
      );
    }
    if (json['arrangement'] is! String ||
        (json['arrangement'] as String).isEmpty) {
      throw FormatException(
        'Program "${json['id']}" is missing a valid "arrangement" field.',
      );
    }
    if (json['company'] is! String || (json['company'] as String).isEmpty) {
      throw FormatException(
        'Program "${json['id']}" is missing a valid "company" field.',
      );
    }

    return Program(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      arrangement: json['arrangement'] as String,
      company: json['company'] as String,
      shortDescription: json['shortDescription'] as String? ?? '',
      fullDescription: json['fullDescription'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      imageUrl: json['imageUrl'] as String?,
      duration: json['duration'] as String?,
      effort: json['effort'] as String?,
      level: json['level'] as String?,
      format: json['format'] as String?,
      instructorName: json['instructorName'] as String?,
      instructorRole: json['instructorRole'] as String?,
      learningOutcomes:
          (json['learningOutcomes'] as List<dynamic>?)?.cast<String>() ?? [],
      registrationOpen: json['registrationOpen'] as bool? ?? true,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'arrangement': arrangement,
    'company': company,
    'shortDescription': shortDescription,
    'fullDescription': fullDescription,
    'tags': tags,
    'imageUrl': imageUrl,
    'duration': duration,
    'effort': effort,
    'level': level,
    'format': format,
    'instructorName': instructorName,
    'instructorRole': instructorRole,
    'learningOutcomes': learningOutcomes,
    'registrationOpen': registrationOpen,
    'isActive': isActive,
    'sortOrder': sortOrder,
  };

  Program copyWith({
    String? id,
    String? title,
    String? category,
    String? arrangement,
    String? company,
    String? shortDescription,
    String? fullDescription,
    List<String>? tags,
    Object? imageUrl = _sentinel,
    Object? duration = _sentinel,
    Object? effort = _sentinel,
    Object? level = _sentinel,
    Object? format = _sentinel,
    Object? instructorName = _sentinel,
    Object? instructorRole = _sentinel,
    List<String>? learningOutcomes,
    bool? registrationOpen,
    bool? isActive,
    int? sortOrder,
  }) {
    return Program(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      arrangement: arrangement ?? this.arrangement,
      company: company ?? this.company,
      shortDescription: shortDescription ?? this.shortDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      tags: tags ?? this.tags,
      imageUrl: imageUrl == _sentinel ? this.imageUrl : imageUrl as String?,
      duration: duration == _sentinel ? this.duration : duration as String?,
      effort: effort == _sentinel ? this.effort : effort as String?,
      level: level == _sentinel ? this.level : level as String?,
      format: format == _sentinel ? this.format : format as String?,
      instructorName: instructorName == _sentinel
          ? this.instructorName
          : instructorName as String?,
      instructorRole: instructorRole == _sentinel
          ? this.instructorRole
          : instructorRole as String?,
      learningOutcomes: learningOutcomes ?? this.learningOutcomes,
      registrationOpen: registrationOpen ?? this.registrationOpen,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

// Sentinel object used by copyWith to distinguish "not passed" from explicit null.
const Object _sentinel = Object();
