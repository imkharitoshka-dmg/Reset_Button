import 'package:shared_preferences/shared_preferences.dart';

import 'reset_session.dart';

class ResetStorageService {
  const ResetStorageService();

  static const _resetSessionDatesKey = 'reset_session_dates';
  static const _resetSessionsKey = 'reset_sessions';

  Future<Set<String>> loadResetSessionDates() async {
    final preferences = await SharedPreferences.getInstance();
    final resetSessions = _loadResetSessionsFromPreferences(preferences);
    final resetSessionDates = resetSessions.map((session) => session.dateKey);
    final savedDates = preferences.getStringList(_resetSessionDatesKey) ?? [];

    return {...savedDates, ...resetSessionDates};
  }

  Future<List<ResetSession>> loadResetSessions() async {
    final preferences = await SharedPreferences.getInstance();
    final resetSessions = _loadResetSessionsFromPreferences(preferences);

    resetSessions.sort((a, b) => b.completedAt.compareTo(a.completedAt));

    return resetSessions;
  }

  Future<void> saveCompletedResetSession({
    required String dateKey,
    required DateTime completedAt,
  }) async {
    final session = ResetSession(
      completedAt: completedAt,
      stateTitle: 'Сброс выполнен',
      scenarioTitle: 'Reset Button',
      durationMinutes: 3,
      result: 'помогло',
    );

    final preferences = await SharedPreferences.getInstance();
    final resetSessionDates =
        preferences.getStringList(_resetSessionDatesKey)?.toSet() ?? {};
    final resetSessions = _loadResetSessionsFromPreferences(preferences)
      ..removeWhere((session) => session.dateKey == dateKey)
      ..add(session);

    resetSessionDates.add(dateKey);

    await preferences.setStringList(
      _resetSessionDatesKey,
      resetSessionDates.toList()..sort(),
    );
    await _saveResetSessions(preferences, resetSessions);
  }

  Future<void> removeResetSession(String dateKey) async {
    final preferences = await SharedPreferences.getInstance();
    final resetSessionDates =
        preferences.getStringList(_resetSessionDatesKey)?.toSet() ?? {};
    final resetSessions = _loadResetSessionsFromPreferences(preferences)
      ..removeWhere((session) => session.dateKey == dateKey);

    resetSessionDates.remove(dateKey);

    await preferences.setStringList(
      _resetSessionDatesKey,
      resetSessionDates.toList()..sort(),
    );
    await _saveResetSessions(preferences, resetSessions);
  }

  Future<void> saveResetSession(ResetSession session) async {
    final preferences = await SharedPreferences.getInstance();
    final resetSessions = _loadResetSessionsFromPreferences(preferences)
      ..add(session);

    await _saveResetSessions(preferences, resetSessions);
  }

  List<ResetSession> _loadResetSessionsFromPreferences(
    SharedPreferences preferences,
  ) {
    final sessionValues = preferences.getStringList(_resetSessionsKey) ?? [];

    return sessionValues.map(ResetSession.fromStorageString).toList();
  }

  Future<void> _saveResetSessions(
    SharedPreferences preferences,
    List<ResetSession> resetSessions,
  ) async {
    resetSessions.sort((a, b) => b.completedAt.compareTo(a.completedAt));

    await preferences.setStringList(
      _resetSessionsKey,
      resetSessions.map((session) => session.toStorageString()).toList(),
    );
  }
}
