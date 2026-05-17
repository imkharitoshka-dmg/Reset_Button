import 'dart:convert';

class ResetSession {
  const ResetSession({
    required this.completedAt,
    required this.stateTitle,
    required this.scenarioTitle,
    required this.durationMinutes,
    required this.result,
    this.note,
  });

  final DateTime completedAt;
  final String stateTitle;
  final String scenarioTitle;
  final int durationMinutes;
  final String result;
  final String? note;

  String get state => stateTitle;

  String get duration {
    if (durationMinutes >= 2 && durationMinutes <= 4) {
      return '$durationMinutes минуты';
    }

    return '$durationMinutes минут';
  }

  String get dateKey {
    final month = completedAt.month.toString().padLeft(2, '0');
    final day = completedAt.day.toString().padLeft(2, '0');

    return '${completedAt.year}-$month-$day';
  }

  String toStorageString() {
    return jsonEncode({
      'completedAt': completedAt.toIso8601String(),
      'stateTitle': stateTitle,
      'scenarioTitle': scenarioTitle,
      'durationMinutes': durationMinutes,
      'result': result,
      'note': note,
    });
  }

  static ResetSession fromStorageString(String value) {
    final json = jsonDecode(value) as Map<String, Object?>;

    return ResetSession(
      completedAt: DateTime.parse(json['completedAt']! as String),
      stateTitle: (json['stateTitle'] ?? json['state'])! as String,
      scenarioTitle: json['scenarioTitle']! as String,
      durationMinutes:
          json['durationMinutes'] as int? ??
          _parseDurationMinutes(json['duration']! as String),
      result: json['result']! as String,
      note: json['note'] as String?,
    );
  }

  static int _parseDurationMinutes(String duration) {
    return int.parse(duration.split(' ').first);
  }
}
