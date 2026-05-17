import 'package:shared_preferences/shared_preferences.dart';

class ResetStorageService {
  const ResetStorageService();

  static const _resetSessionDatesKey = 'reset_session_dates';

  Future<Set<String>> loadResetSessionDates() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getStringList(_resetSessionDatesKey)?.toSet() ?? {};
  }

  Future<void> saveCompletedResetSession(String dateKey) async {
    final preferences = await SharedPreferences.getInstance();
    final resetSessionDates =
        preferences.getStringList(_resetSessionDatesKey)?.toSet() ?? {};

    resetSessionDates.add(dateKey);

    await preferences.setStringList(
      _resetSessionDatesKey,
      resetSessionDates.toList()..sort(),
    );
  }

  Future<void> removeResetSession(String dateKey) async {
    final preferences = await SharedPreferences.getInstance();
    final resetSessionDates =
        preferences.getStringList(_resetSessionDatesKey)?.toSet() ?? {};

    resetSessionDates.remove(dateKey);

    await preferences.setStringList(
      _resetSessionDatesKey,
      resetSessionDates.toList()..sort(),
    );
  }
}
