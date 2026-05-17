import 'dart:convert';

class ResetSession {
  const ResetSession({
    required this.completedAt,
    required this.state,
    required this.scenarioTitle,
    required this.duration,
    required this.result,
    this.note,
  });

  final DateTime completedAt;
  final String state;
  final String scenarioTitle;
  final String duration;
  final String result;
  final String? note;

  String get dateKey {
    final month = completedAt.month.toString().padLeft(2, '0');
    final day = completedAt.day.toString().padLeft(2, '0');

    return '${completedAt.year}-$month-$day';
  }

  String toStorageString() {
    return jsonEncode({
      'completedAt': completedAt.toIso8601String(),
      'state': state,
      'scenarioTitle': scenarioTitle,
      'duration': duration,
      'result': result,
      'note': note,
    });
  }

  static ResetSession fromStorageString(String value) {
    final json = jsonDecode(value) as Map<String, Object?>;

    return ResetSession(
      completedAt: DateTime.parse(json['completedAt']! as String),
      state: json['state']! as String,
      scenarioTitle: json['scenarioTitle']! as String,
      duration: json['duration']! as String,
      result: json['result']! as String,
      note: json['note'] as String?,
    );
  }
}
